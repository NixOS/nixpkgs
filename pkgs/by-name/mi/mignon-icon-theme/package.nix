{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  kdePackages,
  hicolor-icon-theme,
  adwaita-icon-theme,
  mint-y-icons,
  yaru-theme,
}:

stdenvNoCC.mkDerivation (finalAttr: {
  pname = "mignon-icon-theme";
  version = "0-unstable-2025-09-22";

  src = fetchFromGitHub {
    owner = "IgorFerreiraMoraes";
    repo = "Mignon-icon-theme";
    rev = "e2d3fe2f1a55817f0dd93cc91521cda15d1ca784";
    hash = "sha256-JstZ8FtVQLz+wk2xHaskao7uuUxk+slJqqJn0FbqM6I=";
  };

  buildInputs = [
    gtk3
    mint-y-icons
    hicolor-icon-theme
    adwaita-icon-theme
    kdePackages.breeze-icons
    yaru-theme
  ];

  dontDropIconThemeCache = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    theme_name="Mignon-pastel"
    theme_color='#99C0ED'
    dest="$out/share/icons/$theme_name"
    mkdir -p "$dest"

    sed -i "s/%NAME%/''${theme_name//-/ }/g" "./src/index.theme"
    cp -r ./src/index.theme "$dest/index.theme"

    mkdir -p "$dest/scalable"

    sed -i "s/#5294e2/$theme_color/g" "./src/scalable/apps/"*.svg "./src/scalable/places/"default-*.svg
    sed -i "/\ColorScheme-Highlight/s/currentColor/$theme_color/" "./src/scalable/places/"default-*.svg
    sed -i "/\ColorScheme-Background/s/currentColor/#ffffff/" "./src/scalable/places/"default-*.svg

    cp -r ./src/scalable/{apps,devices,mimetypes} "$dest/scalable"
    cp -r ./src/scalable/places "$dest/scalable/places"

    cp -r links/scalable "$dest/"

    find "$dest" -xtype l -exec rm {} +

    ln -sr "$dest/scalable" "$dest/scalable@2x"
    runHook postInstall
  '';

  meta = {
    description = "Flat, Pastel, Cute Icons for Linux";
    homepage = "https://github.com/IgorFerreiraMoraes/Mignon-icon-theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Silk-OT ];
    platforms = lib.platforms.all;
  };
})
