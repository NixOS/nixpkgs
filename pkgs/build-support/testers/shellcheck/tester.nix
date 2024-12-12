# Dependencies (callPackage)
{
  lib,
  stdenv,
  shellcheck,
}:

# testers.shellcheck function
# Docs: doc/build-helpers/testers.chapter.md
# Tests: ./tests.nix
{ src }:
let
  inherit (lib) fileset pathType isPath;
in
stdenv.mkDerivation {
  name = "run-shellcheck";
  src =
    if
      isPath src && pathType src == "regular" # note that for strings this would have been IFD, which we prefer to avoid
    then
      fileset.toSource {
        root = dirOf src;
        fileset = src;
      }
    else
      src;
  nativeBuildInputs = [ shellcheck ];
  doCheck = true;
  dontConfigure = true;
  dontBuild = true;
  checkPhase = ''
    find . -type f -print0 \
      | xargs -0 shellcheck
  '';
  installPhase = ''
    touch $out
  '';
}
