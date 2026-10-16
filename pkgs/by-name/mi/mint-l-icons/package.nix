{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  adwaita-icon-theme,
  hicolor-icon-theme,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "mint-l-icons";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-icons";
    # They don't really do tags, this is just a named commit.
    rev = "dbf96f024f7d06905d35edb40a7f127b8e54af65";
    hash = "sha256-upUgtJ9JA0CbULSPApTemeRI/+Fz2ATXvMwb8OFs7ho=";
  };

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  nativeBuildInputs = [
    gtk3
  ];

  # FIXME: https://hydra.nixos.org/build/287344480/nixlog/5
  dontCheckForBrokenSymlinks = true;
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
    homepage = "https://github.com/linuxmint/mint-l-icons";
    description = "Mint-L icon theme";
    license = lib.licenses.gpl3Plus; # from debian/copyright
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
