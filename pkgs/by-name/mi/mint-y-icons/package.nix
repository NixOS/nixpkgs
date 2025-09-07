{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  adwaita-icon-theme,
  gnome-icon-theme,
  hicolor-icon-theme,
  gtk3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-y-icons";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-y-icons";
    rev = version;
    hash = "sha256-CCkyv0NAfs1sNNiZfAvWgdFILypKk44YyY3cBiSaEZY=";
  };

  propagatedBuildInputs = [
    adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  nativeBuildInputs = [
    gtk3
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-y-icons";
    description = "Mint-Y icon theme";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
