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
<<<<<<< HEAD
  version = "1.8.0";
=======
  version = "1.7.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-icons";
    # They don't really do tags, this is just a named commit.
<<<<<<< HEAD
    rev = "256fe2e44655ce197701e35aefc40f49fe30356d";
    hash = "sha256-BYzgGOVmUZBkz6lG1vFXtqiyUf3xnhXsoP+q4aLLMJs=";
=======
    rev = "fa88b00e10b0978e0309acccfa95d80005422b1a";
    hash = "sha256-XXy1eO0a/5bBnP/inaUa/c09D/6QDmnik1LH382NGIw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/linuxmint/mint-l-icons";
    description = "Mint-L icon theme";
    license = lib.licenses.gpl3Plus; # from debian/copyright
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-l-icons";
    description = "Mint-L icon theme";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
