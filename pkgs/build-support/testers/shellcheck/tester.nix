# Dependencies (callPackage)
{
  lib,
  stdenvNoCC,
  shellcheck,
}:

# testers.shellcheck function
# Docs: doc/build-helpers/testers.chapter.md
# Tests: ./tests.nix
{
  name ? null,
  src,
}:
stdenvNoCC.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;
  name =
    if name == null then
      lib.warn "testers.shellcheck: name will be required in a future release, defaulting to run-shellcheck" "run-shellcheck"
    else
      "shellcheck-${name}";
  inherit src;
  dontUnpack = true; # Unpack phase tries to extract an archive, which we don't want to do with source trees
  nativeBuildInputs = [ shellcheck ];
  doCheck = true;
  dontConfigure = true;
  dontBuild = true;
  checkPhase = ''
    find "$src" -type f -print0 | xargs -0 shellcheck --source-path="$src"
  '';
  installPhase = ''
    touch "$out"
  '';
}
