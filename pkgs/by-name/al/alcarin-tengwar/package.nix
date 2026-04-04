{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alcarin-tengwar";
  version = "0.83";

  src = fetchFromGitHub {
    owner = "Tosche";
    repo = "Alcarin-Tengwar";
    rev = "a4530d430ea01871b0b0a54d1de218d2ffde0ea5";
    hash = "sha256-W1PJ2ABjtGUhWp6XBUq6Zox7uG81tMEs13GidfwgD6Q=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Typeface designed to provide Tengwar symbols";
    homepage = "https://github.com/Tosche/Alcarin-Tengwar";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ gs-101 ];
    platforms = lib.platforms.all;
  };
})
