{
  lib,
  stdenv,
  fetchurl,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  guile,
  libtool,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "guile-sdl2";
  version = "0.8.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://files.dthompson.us/releases/guile-sdl2/guile-sdl2-${version}.tar.gz";
=======
    url = "https://files.dthompson.us/${pname}/${pname}-${version}.tar.gz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-V/XrpFrqOxS5mAphtIt2e3ewflK+HdLFEqOmix98p+w=";
  };

  nativeBuildInputs = [
    pkg-config
    libtool
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    guile
  ];

  configureFlags = [
    "--with-libsdl2-image-prefix=${SDL2_image}"
    "--with-libsdl2-mixer-prefix=${SDL2_mixer}"
    "--with-libsdl2-prefix=${SDL2}"
    "--with-libsdl2-ttf-prefix=${SDL2_ttf}"
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://dthompson.us/projects/guile-sdl2.html";
    description = "Bindings to SDL2 for GNU Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      seppeljordan
    ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://dthompson.us/projects/guile-sdl2.html";
    description = "Bindings to SDL2 for GNU Guile";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
      seppeljordan
    ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
