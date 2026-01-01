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
  pname = "numix-icon-theme-circle";
<<<<<<< HEAD
  version = "25.12.15";
=======
  version = "25.11.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-icon-theme-circle";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Eul4ulMasoY4DNzqeGDxU1trmH3Mrn9Z15gmiFUtM18=";
=======
    sha256 = "sha256-+JV+2PEcXjIUxKTHV+jIejem/oANiMwytzwUPMa2zkc=";
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
    cp -a Numix-Circle{,-Light} $out/share/icons

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
    description = "Numix icon theme (circle version)";
    homepage = "https://numixproject.github.io";
    license = lib.licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
=======
  meta = with lib; {
    description = "Numix icon theme (circle version)";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
