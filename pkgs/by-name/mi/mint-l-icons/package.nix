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
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-icons";
    # They don't really do tags, this is just a named commit.
    rev = "b442277c822c92f7bb68282cb82c7d1a98e3fd37";
    hash = "sha256-vPDEribE/CZwoAK1C9fjbWQEO/NWMWCKCUO/Xw/SxZ0=";
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
    maintainers = teams.cinnamon.members;
  };
}
