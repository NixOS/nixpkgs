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
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-y-icons";
    rev = version;
    hash = "sha256-YciWUzvu+2krbSGz5mqpCVRE22T8/gl4Ln4rILB5Tq8=";
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

  meta = {
    homepage = "https://github.com/linuxmint/mint-y-icons";
    description = "Mint-Y icon theme";
    license = lib.licenses.gpl3; # from debian/copyright
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
