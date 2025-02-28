# Dependencies (callPackage)
{
  lib,
  stdenv,
  shellcheck,
}:

# testers.shellcheck function
# Docs: doc/build-helpers/testers.chapter.md
# Tests: ./tests.nix
{
  name,
  src,
  useNamePrefix ? true,
}:
stdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;
  name = lib.optionalString useNamePrefix "shellcheck-" + name;
  inherit src;
  dontUnpack = true; # Unpack phase tries to extract archive
  nativeBuildInputs = [ shellcheck ];
  doCheck = true;
  dontConfigure = true;
  dontBuild = true;
  checkPhase = ''
    find "$src" -type f -print0 | xargs -0 shellcheck
  '';
  installPhase = ''
    touch "$out"
  '';
}
