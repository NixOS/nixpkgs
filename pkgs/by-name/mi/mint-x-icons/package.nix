{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  adwaita-icon-theme,
  gnome-icon-theme,
  hicolor-icon-theme,
  gtk3,
  humanity-icon-theme,
  ubuntu-themes,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-x-icons";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-x-icons";
    rev = version;
    hash = "sha256-sbNA8fhzhQ6iod3GHb3+/D5jFAWFr1kS+9GhH6Qgla4=";
  };

  propagatedBuildInputs = [
    adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
    humanity-icon-theme
    ubuntu-themes # provides ubuntu-mono-dark
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
    homepage = "https://github.com/linuxmint/mint-x-icons";
    description = "Mint/metal theme based on mintified versions of Clearlooks Revamp, Elementary and Faenza";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
