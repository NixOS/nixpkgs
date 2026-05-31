{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-hyperlegible-mono";
  version = "2.001-unstable-2024-11-20";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "atkinson-hyperlegible-next-mono";
    rev = "154d50362016cc3e873eb21d242cd0772384c8f9";
    hash = "sha256-V0zWbNYT3RGO9vjX+GHfO38ywMozcZVJkBZH+8G5sC0=";
  };

  nativeBuildInputs = [ installFonts ];

  dontBuild = true;

  meta = {
    description = "New (2024) monospace sibling family to Atkinson Hyperlegible Next";
    homepage = "https://www.brailleinstitute.org/freefont/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
