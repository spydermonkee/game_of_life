# Any live col with fewer than two live neighbours dies, as if caused by under-population.
# Any live col with two or three live neighbours lives on to the next generation.
# Any live col with more than three live neighbours dies, as if by overcrowding.
# Any dead col with exactly three live neighbours becomes a live col, as if by reproduction.
require 'pry'

class Board

  ALIVE = "*"
  DEAD = "."

  def initialize(width, height)
    @width = width
    @height = height
    @rows = []
    @rows = create_board
  end

  def create_board
    board = []
    @height.times do
      row = []
      @width.times do
        row << ""
      end
      board << row
    end
    board
  end

  def populate
    @rows.each do |row|
      row.map! do |col|
        col = [ALIVE, DEAD].sample
      end
    end
  end

  def draw_board
    system("clear")
    @rows.each do |row|
      puts row.join
    end
  end

  def generation
    new_rows = create_board
    @rows.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        cell = new_rows[row_index][col_index]
        living_neighbors = count_living_neighbors(row_index, col_index)
        if living_neighbors < 2
          new_rows[row_index][col_index] = DEAD
        elsif living_neighbors > 3
          new_rows[row_index][col_index] = DEAD
        elsif living_neighbors == 3
          new_rows[row_index][col_index] = ALIVE
        else
          new_rows[row_index][col_index] = @rows[row_index][col_index]
        end
      end
    end
    @rows = new_rows
  end

  def is_within_bounds? row, col
    row >= 0 and row < @height and col >= 0 and col < @width
    #   [row, col]
    # else
    #   nil
    # end
  end

  def alive?(neighbor)
    @rows[neighbor[0]][neighbor[1]] == ALIVE
  end

  def count_living_neighbors row, col
    count = 0
    neighbors = find_neighbors row, col

    neighbors.each do |neighbor|
      if (is_within_bounds?(neighbor[0], neighbor[1])) && alive?(neighbor)
        count += 1
      end
    end
    count
  end

  def find_neighbors row, col
    above = row - 1
    below = row + 1
    left = col - 1
    right = col + 1
    location_arrays = [above, below, row].product [left, right]
    location_arrays << [above, col]
    location_arrays << [below, col]
    location_arrays
  end
  # same array +/- 1
  # neighbor arrays, same  or +/-1 index

  def engine
  end
end

class Engine

  def initialize
    @board = Board.new(80, 50)
  end

  def play
  @board.populate
    while true
      @board.draw_board
      sleep 0.5
      @board.generation
    end
  end
end
game = Engine.new
game.play
