{
  runCommand,
  python3,
}:

let
  env = {
    nativeBuildInputs = [ python3 ];
  };
in

runCommand "nixos-test-driver-docstrings" env ''
  mkdir $out
  python3 ${./extract-docstrings.py} ${./test_driver/machine.py} \
    > $out/machine-methods.md
''
