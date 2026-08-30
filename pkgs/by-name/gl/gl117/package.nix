{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  SDL,
  libglut,
  SDL_mixer,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gl-117";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/gl-117/gl-117/GL-117%20Source/gl-117-${finalAttrs.version}.tar.bz2";
    sha256 = "1yvg1rp1yijv0b45cz085b29x5x0g5fkm654xdv5qwh2l6803gb4";
  };

  nativeBuildInputs = [
    automake
    autoconf
  ];
  buildInputs = [
    libGLU
    libGL
    SDL
    libglut
    SDL_mixer
    libtool
  ];

  meta = {
    description = "Air combat simulator";
    mainProgram = "gl-117";
    homepage = "https://sourceforge.net/projects/gl-117";
    maintainers = with lib.maintainers; [ raskin ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
