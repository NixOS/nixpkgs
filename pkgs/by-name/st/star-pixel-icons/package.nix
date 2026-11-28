{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  hicolor-icon-theme,
  adwaita-icon-theme,
  kdePackages,
  gnome-icon-theme,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "star-pixel-icons";
  version = "0-unstable-03-09-2025";

  src = fetchFromGitHub {
    owner = "Starciad";
    repo = "star-pixel-icons-theme";
    rev = "44625afc5ee831f1513d6687c601d4805892129c";
    hash = "sha256-XDAWlCbdVAC74qZ/E1sok9jRkB0yForhQnVVg1WYnQc=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
    adwaita-icon-theme
    gnome-icon-theme
    kdePackages.breeze-icons
    kdePackages.oxygen-icons
  ];

  dontDropIconThemeCache = true;

  dontWrapQtApps = true;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    ICON_DIR=$out/share/icons/star-pixel-icons
    mkdir -p $ICON_DIR
    cp -r src/SPI/* $ICON_DIR
    gtk-update-icon-cache $ICON_DIR

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Starciad/star-pixel-icons-theme";
    description = "Pixel icon theme for Linux";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.EarthGman ];
  };
}
