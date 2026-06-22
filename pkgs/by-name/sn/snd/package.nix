{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  alsa-lib,
  fftw,
  gsl,
  motif,
  libxt,
  libxpm,
  libxft,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snd";
  version = "26.4";

  src = fetchurl {
    url = "mirror://sourceforge/snd/snd-${finalAttrs.version}.tar.gz";
    hash = "sha256-IAEmh3J6t2IHIi8DAW6xU4mjkf4cXIMjT6CTNejtxqY=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fftw
    gsl
    motif
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ [
    libxext
    libxft
    libxpm
    libxt
  ];

  configureFlags = [
    "--with-motif"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Sound editor";
    homepage = "https://ccrma.stanford.edu/software/snd/";
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
    maintainers = [ ];
    mainProgram = "snd";
  };
})
