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
  mergeInputs = name: lib.concatLists (lib.catAttrs name
    ([attrs] ++ inputsFrom));

  rest = builtins.removeAttrs attrs [
    "inputsFrom"
    "buildInputs"
    "nativeBuildInputs"
    "propagatedBuildInputs"
    "propagatedNativeBuildInputs"
    "shellHook"
  ];
in

stdenv.mkDerivation ({
  name = "nix-shell";
  phases = ["nobuildPhase"];

  buildInputs = mergeInputs "buildInputs";
  nativeBuildInputs = mergeInputs "nativeBuildInputs";
  propagatedBuildInputs = mergeInputs "propagatedBuildInputs";
  propagatedNativeBuildInputs = mergeInputs "propagatedNativeBuildInputs";

  shellHook = lib.concatStringsSep "\n" (lib.catAttrs "shellHook"
    (lib.reverseList inputsFrom ++ [attrs]));

  nobuildPhase = ''
    echo
    echo "This derivation is not meant to be built, aborting";
    echo
    exit 1
  '';
} // rest)
