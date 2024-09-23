{ stdenvNoCC
, lib
, fetchFromGitHub
, adwaita-icon-theme
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-icons";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # https://github.com/linuxmint/mint-l-icons/issues/11
    rev = "ee03e6dad0b1f9e25847977eae42766e2ddd4877";
    hash = "sha256-OKlkqDp9mZOeM4M9QN9H0WH4k+5eMEUshvadaV6qhBA=";
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
    homepage = "https://github.com/linuxmint/mint-l-icons";
    description = "Mint-L icon theme";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
