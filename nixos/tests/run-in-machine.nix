{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };

let
  output = runInMachine {
    drv = pkgs.hello;
    machine = { config, pkgs, ... }: { /* services.sshd.enable = true; */ };
  };
in pkgs.runCommand "verify-output" { inherit output; } ''
  if [ ! -e "$output/bin/hello" ]; then
    echo "Derivation built using runInMachine produced incorrect output:" >&2
    ls -laR "$output" >&2
    exit 1
  fi
  "$output/bin/hello" > "$out"
''
