{ lib, stdenv }:

# A special kind of derivation that is only meant to be consumed by the
# nix-shell.
{
  inputsFrom ? [], # a list of derivations whose inputs will be made available to the environment
  buildInputs ? [],
  nativeBuildInputs ? [],
  propagatedBuildInputs ? [],
  propagatedNativeBuildInputs ? [],
  ...
}@attrs:
let
  mergeInputs = name:
    let
      op = item: sum: sum ++ item."${name}" or [];
      nul = [];
      list = [attrs] ++ inputsFrom;
    in
      lib.foldr op nul list;

  rest = builtins.removeAttrs attrs [
    "inputsFrom"
    "buildInputs"
    "nativeBuildInputs"
    "propagatedBuildInputs"
    "propagatedNativeBuildInputs"
  ];
in

stdenv.mkDerivation ({
  name = "nix-shell";
  phases = ["nobuildPhase"];

  buildInputs = mergeInputs "buildInputs";
  nativeBuildInputs = mergeInputs "nativeBuildInputs";
  propagatedBuildInputs = mergeInputs "propagatedBuildInputs";
  propagatedNativeBuildInputs = mergeInputs "propagatedNativeBuildInputs";

  nobuildPhase = ''
    echo
    echo "This derivation is not meant to be built, aborting";
    echo
    exit 1
  '';
} // rest)
