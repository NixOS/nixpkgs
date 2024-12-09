{ lib }:

let echo_colored_body = start_escape:
      # Body of a function that behaves like "echo" but
      # has the output colored by the given start_escape
      # sequence. E.g.
      #
      # * echo_x "Building ..."
      # * echo_x -n "Running "
      #
      # This is more complicated than apparent at first sight
      # because:
      #   * The color markers and the text must be print
      #     in the same echo statement. Otherise, other
      #     intermingled text from concurrent builds will
      #     be colored as well.
      #   * We need to preserve the trailing newline of the
      #     echo if and only if it is present. Bash likes
      #     to strip those if we capture the output of echo
      #     in a variable.
      #   * Leading "-" will be interpreted by test as an
      #     option for itself. Therefore, we prefix it with
      #     an x in `[[ "x$1" =~ ^x- ]]`.
      ''
      local echo_args="";
      while [[ "x$1" =~ ^x- ]]; do
        echo_args+=" $1"
        shift
      done

      local start_escape="$(printf '${start_escape}')"
      local reset="$(printf '\033[0m')"
      echo $echo_args $start_escape"$@"$reset
      '';
  echo_conditional_colored_body = colors: start_escape:
      if colors == "always"
      then (echo_colored_body start_escape)
      else ''echo "$@"'';
in {
  echo_colored = colors: ''
    echo_colored() {
      ${echo_conditional_colored_body colors ''\033[0;1;32m''}
    }

    echo_error() {
      ${echo_conditional_colored_body colors ''\033[0;1;31m''}
    }
   '';

  noisily = colors: verbose: ''
    noisily() {
      ${lib.optionalString verbose ''
        echo_colored -n "Running "
        echo $@
      ''}
      $@
    }
  '';
}
