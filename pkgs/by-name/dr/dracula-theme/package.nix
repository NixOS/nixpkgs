{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  gtk-engine-murrine,
}:

let
  themeName = "Dracula";
<<<<<<< HEAD
  version = "4.0.0-unstable-2025-12-26";
=======
  version = "4.0.0-unstable-2025-11-20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenvNoCC.mkDerivation {
  pname = "dracula-theme";
  inherit version;

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
<<<<<<< HEAD
    rev = "d4163a5e6e598053567038c53777bf7682ecd17f";
    hash = "sha256-FalI8DvTCVzCHlZFh9j+CD0WMtELd174JaUWvuBHRRY=";
=======
    rev = "c04b3531f8db463cbc0481546f4477e455908473";
    hash = "sha256-eT0j//ALSqyhHMOBqTYtr9z/erov8IKHDd697vybMAo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a {assets,cinnamon,gnome-shell,gtk-2.0,gtk-3.0,gtk-3.20,gtk-4.0,index.theme,metacity-1,unity,xfwm4} $out/share/themes/${themeName}

    cp -a kde/{color-schemes,plasma} $out/share/
    cp -a kde/kvantum $out/share/Kvantum
    mkdir -p $out/share/aurorae/themes
    cp -a kde/aurorae/* $out/share/aurorae/themes/
    mkdir -p $out/share/sddm/themes
    cp -a kde/sddm/* $out/share/sddm/themes/

    mkdir -p $out/share/icons/Dracula-cursors
    mv kde/cursors/Dracula-cursors/index.theme $out/share/icons/Dracula-cursors/cursor.theme
    mv kde/cursors/Dracula-cursors/cursors $out/share/icons/Dracula-cursors/cursors

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

<<<<<<< HEAD
  meta = {
    description = "Dracula variant of the Ant theme";
    homepage = "https://github.com/dracula/gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ alexarice ];
=======
  meta = with lib; {
    description = "Dracula variant of the Ant theme";
    homepage = "https://github.com/dracula/gtk";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
