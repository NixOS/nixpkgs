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
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-x-icons";
    rev = version;
    hash = "sha256-Ea0NkN9vnfqqqXpE+aM6zca1m7ri4mP1DMTQhvx9guQ=";
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
