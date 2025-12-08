{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
}:
stdenvNoCC.mkDerivation {
  pname = "kanagawa-icon-theme";
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "825ac8d90e16ce612b487f29ee6db60b5dc63012";
    hash = "sha256-YOA3qBtMcz0to2yOStd33rF4NGhZWiLAJMo7MHx9nqM=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a icons/* $out/share/icons
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache -f $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Icon theme for the Kanagawa colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iynaix ];
    platforms = platforms.linux;
  };
}
