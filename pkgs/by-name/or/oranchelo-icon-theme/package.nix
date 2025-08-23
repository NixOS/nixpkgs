{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  kdePackages,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "oranchelo-icon-theme";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "OrancheloTeam";
    repo = "oranchelo-icon-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IDsZj/X9rFSdDpa3bL6IPEPCRe5GustPteDxSbfz+SA=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    hicolor-icon-theme
  ];

  # breeze-icons propagates qtbase
  dontWrapQtApps = true;

  dontDropIconThemeCache = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postInstall = ''
    # space in icon name causes gtk-update-icon-cache to fail
    mv "$out/share/icons/Oranchelo/apps/scalable/ grsync.svg" "$out/share/icons/Oranchelo/apps/scalable/grsync.svg"

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done
  '';
  dontCheckForBrokenSymlinks = true;

  meta = {
    description = "Oranchelo icon theme";
    homepage = "https://github.com/OrancheloTeam/oranchelo-icon-theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _414owen ];
  };
})
