{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  breeze-icons,
  hicolor-icon-theme,
  pantheon,
}:

stdenvNoCC.mkDerivation rec {
  pname = "marwaita-icons";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "marwaita-icons";
    rev = version;
    hash = "sha256-UehujziT13kA9ltjyCvbSDTEpR8ISxoBpoLj22Zih8k=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    hicolor-icon-theme
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;
  dontWrapQtApps = true;

  # FIXME: https://github.com/darkomarko42/Marwaita-Icons/issues/3
  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Marwaita* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done

    runHook postInstall
  '';

  meta = {
    description = "Icon pack for linux";
    homepage = "https://github.com/darkomarko42/Marwaita-Icons";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
