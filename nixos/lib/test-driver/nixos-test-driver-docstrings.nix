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
  python3 ${./src/extract-docstrings.py} ${./src/test_driver/machine/__init__.py} \
    > $out/machine-methods.md
''
