{
  lib,
  runCommandNoCC,
  fetchFromGitHub,
  gtk3,
  kdePackages,
  hicolor-icon-theme,
  adwaita-icon-theme,
  mint-y-icons,
}:

runCommandNoCC "mignon-icon-theme-unstable-2025-09-05" {
  pname = "mignon-icon-theme";
  version = "unstable-2025-09-05";

  src = fetchFromGitHub {
    owner = "IgorFerreiraMoraes";
    repo = "Mignon-icon-theme";
    rev = "5b065dba10b0fbaec6f8e65e604f3fca193c31a4";
    hash = "sha256-Rtr6NFGVMgs1Oqu/XqHiqaWeGsuvFzdwd/kbqTntQUg=";
  };

  buildInputs = [
    gtk3
    mint-y-icons
    hicolor-icon-theme
    adwaita-icon-theme
    kdePackages.breeze-icons
  ];

  dontBuild = true;
  dontDropIconThemeCache = true;

  meta = with lib; {
    description = "Flat, Pastel, Cute Icons for Linux";
    homepage = "https://github.com/IgorFerreiraMoraes/Mignon-icon-theme";
    license = lib.licenses.gpl3Only;
    maintainers = with maintainers; [ Silk-OT ];
    mainProgram = "mignon-icon-theme";
    platforms = platforms.linux;
  };
} ''
  theme_name="Mignon-pastel"
  theme_color='#99C0ED'
  dest="$out/share/icons/$theme_name"
  mkdir -p "$dest"

  cp -r $src/* .
  chmod u+w -R .
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
''
