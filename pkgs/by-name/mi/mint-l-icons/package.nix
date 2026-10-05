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
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-icons";
    # They don't really do tags, this is just a named commit.
    rev = "0b22e7cc69f11e8472065cfc9309add51f403cfc";
    hash = "sha256-AtCQMgSmeMV7rU6XaT42bD4DDfe5acVIxQ1JwKYQb8c=";
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
