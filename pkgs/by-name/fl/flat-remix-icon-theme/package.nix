{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  pantheon,
  gnome-icon-theme,
  hicolor-icon-theme,
  libsForQt5,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "flat-remix-icon-theme";
  version = "20240201";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "flat-remix";
    tag = finalAttrs.version;
    hash = "sha256-3TkBRgoT2AW0Sb0CrXdxh53/jYARAMFC/TIj/r/zruo=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    libsForQt5.breeze-icons
    pantheon.elementary-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontFixup = true;
  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv Flat-Remix* $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
    symlinkParentIconThemes
    recordPropagatedDependencies
  '';

  meta = {
    description = "Flat remix is a pretty simple icon theme inspired on material design";
    homepage = "https://drasite.com/flat-remix";
    license = with lib.licenses; [ gpl3Only ];
    # breeze-icons and pantheon.elementary-icon-theme dependencies are restricted to linux
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
