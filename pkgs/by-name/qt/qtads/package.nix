{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  fluidsynth,
  libsndfile,
  libvorbis,
  mpg123,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtads";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "realnc";
    repo = "qtads";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KIqufpvl7zeUtDBXUOAZxBIbfv+s51DoSaZr3jol+bw=";
  };

  nativeBuildInputs = [
    pkg-config
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    fluidsynth
    libsndfile
    libvorbis
    mpg123
    qt5.qtbase
  ];

  meta = {
    homepage = "https://realnc.github.io/qtads/";
    description = "Multimedia interpreter for TADS games";
    mainProgram = "qtads";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = with lib.maintainers; [ orivej ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
