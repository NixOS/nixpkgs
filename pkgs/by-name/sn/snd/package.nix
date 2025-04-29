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
  version = "25.3";

  src = fetchurl {
    url = "mirror://sourceforge/snd/snd-${version}.tar.gz";
    hash = "sha256-YZcMojm68CiyEH8shmoIH9Tl27RSV20q7UId7L9rhYM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
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

  meta = with lib; {
    description = "Sound editor";
    homepage = "https://ccrma.stanford.edu/software/snd/";
    platforms = platforms.unix;
    license = licenses.free;
    maintainers = [ ];
    mainProgram = "snd";
  };
}
