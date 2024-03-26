{ runCommand, aerospace }:


let
  inherit (aerospace) pname version;
in

runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    # tr is required as the version has a capital in Beta as of 0.9.0-Beta
    # whilst nix packages must not have capitals in version names
    if [[ `${aerospace}/bin/${pname} --version | tr '[:upper:]' '[:lower:]'` != *"${version}"*  ]]; then
      echo "Error: program version does not match package version"
      exit 1
    fi
    ${aerospace}/bin/aerospace --version >/dev/null
    touch $out
  ''
