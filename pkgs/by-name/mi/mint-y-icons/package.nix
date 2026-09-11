{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  adwaita-icon-theme,
  hicolor-icon-theme,
  gtk3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-y-icons";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-y-icons";
    rev = version;
    hash = "sha256-aDuM3IpnQdkdjNSV0U/wwn1pXVFbPKEeZhDxt9GPcFE=";
  };

  propagatedBuildInputs = [
    adwaita-icon-theme
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
