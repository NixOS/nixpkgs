{ runCommand, vhs }:

let
  inherit (vhs) pname version;
in

runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    if [[ `${vhs}/bin/vhs -v` != *"${version}"* ]]; then
      echo "Error: program version does not match package version"
      exit 1
    fi
    ${vhs}/bin/vhs new demo.tape
    ${vhs}/bin/vhs < demo.tape | grep "Welcome to VHS!"
    touch $out
  ''

