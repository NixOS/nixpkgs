{
  lib,
  shfmt,
  stdenvNoCC,
}:
# See https://nixos.org/manual/nixpkgs/unstable/#tester-shfmt
# or doc/build-helpers/testers.chapter.md
{
  name,
  src,
  indent ? 2,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  inherit src indent;
  name = "shfmt-${name}";
  dontUnpack = true; # Unpack phase tries to extract archive
  nativeBuildInputs = [ shfmt ];
  doCheck = true;
  dontConfigure = true;
  dontBuild = true;
  checkPhase = ''
    shfmt --diff --indent $indent --simplify "$src"
  '';
  installPhase = ''
    touch "$out"
  '';
})
