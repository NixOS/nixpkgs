{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libGL,
  SDL,
  SDL_image,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.9.3";
  pname = "meterbridge";

  src = fetchurl {
    url = "http://plugin.org.uk/meterbridge/meterbridge-${finalAttrs.version}.tar.gz";
    sha256 = "0s7n3czfpil94vsd7iblv4xrck9c7zvsz4r3yfbkqcv85pjz1viz";
  };

  patches = [
    ./buf_rect.patch
    ./fix_build_with_gcc-5.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libGL
    SDL
    SDL_image
    libjack2
  ];

  meta = {
    description = "Various meters (VU, PPM, DPM, JF, SCO) for Jack Audio Connection Kit";
    homepage = "http://plugin.org.uk/meterbridge/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
    mainProgram = "meterbridge";
  };
})
