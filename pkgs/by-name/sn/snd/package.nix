{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  alsa-lib,
  fftw,
  gsl,
  motif,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "snd";
  version = "25.5";

  src = fetchurl {
    url = "mirror://sourceforge/snd/snd-${version}.tar.gz";
    hash = "sha256-IVGaHcsZGEPRk04UdjlYfDRYLHAEzeyhx2HWV3Ks2Bo=";
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
  ++ (with xorg; [
    libXext
    libXft
    libXpm
    libXt
  ]);

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
}
