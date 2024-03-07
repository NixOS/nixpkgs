/*
  Run with:

      cd nixpkgs
      nix-build -A tests.trivial-builders.writeShellApplication
*/

{ lib, writeShellApplication, runCommand }:
let
  pkg = writeShellApplication {
    name = "test-script";
    excludeShellChecks = [ "SC2016" ];
    text = ''
      echo -e '#!/usr/bin/env bash\n' \
       'echo "$SHELL"' > /tmp/something.sh  # this line would normally
                                            # ...cause shellcheck error
    '';
  };
in
  assert pkg.meta.mainProgram == "test-script";
  runCommand "test-writeShellApplication" { } ''

    echo Testing if writeShellApplication builds without shellcheck error...

    target=${lib.getExe pkg}

    touch $out
  ''

