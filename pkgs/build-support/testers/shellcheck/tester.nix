# Dependencies (callPackage)
{
  lib,
  stdenv,
  runCommand,
  shellcheck,
}:

# testers.shellcheck function
# Docs: doc/build-helpers/testers.chapter.md
# Tests: ./tests.nix
{ src }:
let
  inherit (lib) pathType isPath;
in
stdenv.mkDerivation {
  name = "run-shellcheck";
  src =
    if
      isPath src && pathType src == "regular" # note that for strings this would have been IFD, which we prefer to avoid
    then
      runCommand "testers-shellcheck-src" { } ''
        mkdir $out
        cp ${src} $out
      ''
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
