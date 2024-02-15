/*
  Run with:

      cd nixpkgs
      nix-build -A tests.trivial-builders.writeCBin
*/

{ lib, writeCBin, runCommand }:
let
  output = "hello";
  pkg = writeCBin "test-script" ''
    #include <stdio.h>
    int main () {
      printf("hello\n");
      return 0;
    }
  '';
in
  assert pkg.meta.mainProgram == "test-script";
  runCommand "test-writeCBin" { } ''

    echo Testing with getExe...

    target=${lib.getExe pkg}
    expected=${lib.escapeShellArg output}
    got=$("$target")
    if [[ "$got" != "$expected" ]]; then
      echo "wrong output: expected $expected, got $got"
      exit 1
    fi

    echo Testing with makeBinPath...

    PATH="${lib.makeBinPath [ pkg ]}:$PATH"
    got=$(test-script)
    if [[ "$got" != "$expected" ]]; then
      echo "wrong output: expected $expected, got $got"
      exit 1
    fi

    touch $out
  ''

