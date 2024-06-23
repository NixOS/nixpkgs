{ runCommand, postrunner, stdenv }:

let
  inherit (postrunner) name;
  version = (import ./gemset.nix).postrunner.version;
in

runCommand "${name}-tests" { meta.timeout = 3; }
  ''
    # get version of installed program and compare with package version
    if [[ `${postrunner}/bin/postrunner version` != *"${version}"*  ]]; then
      echo "Error: program version does not match package version"
      exit 1
    fi
    # run help
    ${postrunner}/bin/postrunner --help | grep 'Usage postrunner .command. .options.'
    echo All test for $name passed
    # needed for Nix to register the command as successful
    touch $out
  ''
