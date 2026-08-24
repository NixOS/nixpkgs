{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  adwaita-icon-theme,
  hicolor-icon-theme,
  gtk3,
  humanity-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-x-icons";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-x-icons";
    rev = version;
    hash = "sha256-gGldt2tGko3IukpKjn0xGAe4cL21YPCECJfcOX5F8n0=";
  };

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
    humanity-icon-theme
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
    homepage = "https://github.com/linuxmint/mint-x-icons";
    description = "Mint/metal theme based on mintified versions of Clearlooks Revamp, Elementary and Faenza";
    license = lib.licenses.gpl3Plus; # from debian/copyright
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
