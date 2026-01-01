{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  numix-icon-theme,
  hicolor-icon-theme,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "numix-icon-theme-square";
<<<<<<< HEAD
  version = "25.12.27";
=======
  version = "25.11.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-icon-theme-square";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-D4Tclt0GQ70Ka4tmMPhOPVSHL/42hAB2D0PLe9iyN+U=";
=======
    sha256 = "sha256-fHNOzalDY736/4L317QpyFWan+349rWwRz2Kr5FH28A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    numix-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Numix-Square{,-Light} $out/share/icons

    for panel in $out/share/icons/*/*/panel; do
      ln -sf $(realpath ${numix-icon-theme}/share/icons/Numix/16/$(readlink $panel)) $panel
    done

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

<<<<<<< HEAD
  meta = {
    description = "Numix icon theme (square version)";
    homepage = "https://numixproject.github.io";
    license = lib.licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
=======
  meta = with lib; {
    description = "Numix icon theme (square version)";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
