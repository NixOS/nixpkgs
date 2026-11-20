{
  lib,
  stdenv,
  fetchFromCodeberg,
}:

stdenv.mkDerivation {
  pname = "plasma-overdose-kde-theme";
  version = "0-unstable-2026-04-23";

  src = fetchFromCodeberg {
    owner = "notify-ctrl";
    repo = "Plasma-Overdose";
    rev = "2ca54efdeef230277294a04b0124c5572a16de0b";
    hash = "sha256-rdUMoV1aOEmCEP7OajPsxpKz0q2hhPpP1MMQbqe0AAE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mkdir -p $out/share/color-schemes
    cp plasma/desktoptheme/Plasma-Overdose/colors $out/share/color-schemes/Plasma-Overdose.colors

    mv plasma $out/share/plasma
    mv wallpapers $out/share/wallpapers

    mkdir -p $out/share/aurorae
    mv aurorae $out/share/aurorae/themes

    mkdir -p $out/share/kwin/decorations
    mv kwin/Plasma-Overdose-KWinDeco $out/share/kwin/decorations

    mkdir -p $out/share/icons/Plasma-Overdose
    mv cursors/index.theme $out/share/icons/Plasma-Overdose/cursor.theme
    mv cursors/cursors $out/share/icons/Plasma-Overdose/cursors

    mkdir -p $out/share/sounds
    mv sounds $out/share/sounds/PlasmaOverdose

    runHook postInstall
  '';

  meta = {
    description = "Cute KDE theme inspired by the game Needy Girl Overdose";
    homepage = "https://codeberg.org/notify-ctrl/Plasma-Overdose";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      takagiy
      shadowrz
    ];
  };
}
