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
  version = "26.0";

  src = fetchurl {
    url = "mirror://sourceforge/snd/snd-${finalAttrs.version}.tar.gz";
    hash = "sha256-8b1jyf/6Jo/0NVy+Zvwb4gJ48j5Z94JFtVMgYB03CYc=";
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
