{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  output = runInMachine {
    drv = pkgs.hello;
    machine = { ... }: { /* services.sshd.enable = true; */ };
  };

  test = pkgs.runCommand "verify-output" { inherit output; } ''
    if [ ! -e "$output/bin/hello" ]; then
      echo "Derivation built using runInMachine produced incorrect output:" >&2
      ls -laR "$output" >&2
      exit 1
    fi
    "$output/bin/hello" > "$out"
  '';

in test // { inherit test; } # To emulate behaviour of makeTest
