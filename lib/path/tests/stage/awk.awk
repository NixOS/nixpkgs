# Return a random array key according to the given weights array.
# The weights need to be normalised, you may use `normalise_weights` for this
# Example:
#   weights["a"] = 3
#   weights["b"] = 1
#   normalise_weights(weights)
#   gen_weighted(weights)
function gen_weighted(weights,        random_value) {
  random_value = rand();
  for (key in weights) {
    if (random_value < weights[key]) {
      return key
    } else {
      random_value -= weights[key]
    }
  }
}

# Normalise an array of weights, scaling them such that they total 1
# Example:
#   weights["a"] = 3
#   weights["b"] = 1
#   normalise_weights(weights)
#   print weights["a"] # 0.75
#   print weights["b"] # 0.25
function normalise_weights(weights,       total) {
  total=0
  for (key in weights) {
    total += weights[key]
  }
  for (key in weights) {
    weights[key] /= total
  }
}

# Generates a random integer between the first (inclusive) and the second (exclusive) argument
# Example:
#   gen_int_range(10, 20) # Lowest possible value is 10, highest possible value is 19
function gen_int_range(a, b) {
  return int(a + rand() * (b - a))
}

# Generates a random length >= 0 using a geometric distribution. The argument is the expected length
# Example:
#   gen_length(10) # Lower numbers are more common,
#                  # but higher numbers are also possible,
#                  # the average is 10
function gen_length(e,        p, result) {
  # Generates a geometric distribution with p = 1 / e from a uniform distribution
  # See https://en.wikipedia.org/wiki/Geometric_distribution#Related_distributions
  return int(log(rand()) / log(1 - 1 / e))
}

BEGIN {
}

function gen_valid_subpath() {
  return gen_subpath_with("valid", subpath_average_length)
}

function gen_subpath(        desired_type) {
  desired_type = gen_weighted(subpath_type_weights)
  return gen_subpath_with(desired_type, subpath_average_length)
}

function gen_subpath_with(desired_type, average_length,        left, result) {

  do {
    left = gen_length(average_length)
    result = ""
    while (left > 0) {
      switch (gen_weighted(subpath_char_weights)) {
        case "ascii":
          result = result sprintf("%c", gen_int_range(32, 128))
          break
        case "dot":
          result = result "."
          break
        case "slash":
          result = result "/"
          break
      }
      left = left - 1
    }
  } while (subpath_type(result) != desired_type)
  return result
}

function subpath_type(subpath,        components, i) {
  if (subpath == "") {
    return "invalid/empty"
  } else if (substr(subpath, 0, 1) == "/") {
    return "invalid/absolute"
  }
  split(subpath, parts, "/")
  for (i in parts) {
    if (parts[i] == "..") {
      return "invalid/parent"
    }
  }
  return "valid"
}

function subpath_is_valid(subpath) {
  return subpath_type(subpath) == "valid"
}

function write(file, string) {
  # print "Writing string " string " to " case_dir "/" i "/" file
  printf "%s", string > case_dir "/" i "/" file
}

BEGIN {
  subpath_char_weights["dot"] = 1
  subpath_char_weights["slash"] = 1
  subpath_char_weights["ascii"] = 2
  normalise_weights(subpath_char_weights)

  subpath_type_weights["valid"] = 200
  subpath_type_weights["invalid/empty"] = 1
  subpath_type_weights["invalid/absolute"] = 5
  subpath_type_weights["invalid/parent"] = 30
  normalise_weights(subpath_type_weights)

  subpath_average_length = 8

  srand(seed)
  for (i = 0; i < count; i++) {
    stage()
  }
}
