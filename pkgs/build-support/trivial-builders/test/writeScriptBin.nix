/*
  Run with:

      cd nixpkgs
      nix-build -A tests.trivial-builders.writeShellScriptBin
*/

{ lib, writeScriptBin, runCommand }:
let
  output = "hello";
  pkg = writeScriptBin "test-script" ''
    echo ${lib.escapeShellArg output}
  '';
in
  assert pkg.meta.mainProgram == "test-script";
  runCommand "test-writeScriptBin" { } ''

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

