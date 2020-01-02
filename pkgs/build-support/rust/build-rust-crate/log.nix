{ lib }:
{
  echo_build_heading = colors: ''
    echo_build_heading() {
     start=""
     end=""
     ${lib.optionalString (colors == "always") ''
       start="$(printf '\033[0;1;32m')" #set bold, and set green.
       end="$(printf '\033[0m')" #returns to "normal"
     ''}
     if (( $# == 1 )); then
       echo "$start""Building $1""$end"
     else
       echo "$start""Building $1 ($2)""$end"
     fi
    }
  '';
  noisily = colors: verbose: ''
    noisily() {
      start=""
      end=""
      ${lib.optionalString (colors == "always") ''
        start="$(printf '\033[0;1;32m')" #set bold, and set green.
        end="$(printf '\033[0m')" #returns to "normal"
      ''}
  	  ${lib.optionalString verbose ''
        echo -n "$start"Running "$end"
        echo $@
  	  ''}
  	  $@
    }
  '';
}
