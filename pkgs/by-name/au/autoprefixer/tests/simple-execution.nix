{ runCommand, autoprefixer }:

let
  inherit (autoprefixer) pname version;
in

runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    # get version of installed program and compare with package version
    claimed_version="$(${autoprefixer}/bin/autoprefixer --version | awk '{print $2}')"
    if [[ "$claimed_version" != "${version}" ]]; then
      echo "Error: program version does not match package version ($claimed_version != ${version})"
      exit 1
    fi

    # run dummy commands
    ${autoprefixer}/bin/autoprefixer --help > /dev/null
    ${autoprefixer}/bin/autoprefixer --info > /dev/null

    # Testing the actual functionality is done in the test for postcss
    # because autoprefixer is a postcss plugin

    # needed for Nix to register the command as successful
    touch $out
  ''
