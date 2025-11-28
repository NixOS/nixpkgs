{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  adwaita-icon-theme,
  gnome-icon-theme,
  hicolor-icon-theme,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "mint-l-icons";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-icons";
    # They don't really do tags, this is just a named commit.
    rev = "fa88b00e10b0978e0309acccfa95d80005422b1a";
    hash = "sha256-XXy1eO0a/5bBnP/inaUa/c09D/6QDmnik1LH382NGIw=";
  };

  propagatedBuildInputs = [
    adwaita-icon-theme
    gnome-icon-theme
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

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-l-icons";
    description = "Mint-L icon theme";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
