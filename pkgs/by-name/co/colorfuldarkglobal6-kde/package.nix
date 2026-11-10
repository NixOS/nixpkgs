{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "colorfuldarkglobal6-kde";
  version = "0-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Colorful-Plasma-Themes";
    rev = "67fe0058dc44c3b86898fee1c930d718fcc834dc";
    hash = "sha256-bC4uAHnR4xZ50nEmG4Xyr0APvgL2r0BMD6b4a8UJbD0=";
  };

  installPhase = ''
    mkdir -p "$out/share/plasma/desktoptheme/Colorful-Dark-Global-6"
    mkdir -p "$out/share/aurorae/themes/Colorful-Dark-6"
    mkdir -p "$out/share/color-schemes"
    mkdir -p "$out/share/konsole"
    mkdir -p "$out/share/icons/Colorful-Dark-6"

    cp -rd "Colorful Global Themes/Colorful-Dark-Global-6"/* -t "$out/share/plasma/desktoptheme/Colorful-Dark-Global-6/"

    cp -rd "Colorful Window Decorations/Colorful-Blur-Dark-Aurorae-6" -t "$out/share/aurorae/themes/"
    cp -rd "Colorful Window Decorations/Colorful-Dark-Aurorae-6" -t "$out/share/aurorae/themes/"
    cp -rd "Colorful Window Decorations/Colorful-Dark-Color-Aurorae-6" -t "$out/share/aurorae/themes/"

    cp -rd "Colorful Konsole Color Schemes"/* -t "$out/share/konsole"

    cp -rd "Colorful Color Schemes"/* -t "$out/share/color-schemes/"
    cp -rd "Colorful Icons Themes/Colorful-Dark-Icons" -t "$out/share/icons/"
  '';

  meta = {
    description = "Port of the Colorful-Dark-Global-6 theme for Plasma";
    homepage = "https://github.com/L4ki/Colorful-Plasma-Themes/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.liamthexpl0rer ];
    platforms = lib.platforms.all;
  };
}
