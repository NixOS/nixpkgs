{
  lib,
  stdenv,
  fetchurl,
  hamlib,
  fltk13,
  libjpeg,
  libpng,
  portaudio,
  libsndfile,
  libsamplerate,
  libpulseaudio,
  libXinerama,
  gettext,
  pkg-config,
  alsa-lib,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "fldigi";
  version = "4.2.07";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-9KpTh0fBqiVC901R1PdH2SEya32Ijl+jkxSSpFuhs6o=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libXinerama
    gettext
    hamlib
    fltk13
    libjpeg
    libpng
    portaudio
    libsndfile
    libsamplerate
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    libpulseaudio
    alsa-lib
    udev
  ];

  env.CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++14";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Digital modem program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      relrod
      ftrvxmtrx
    ];
    platforms = platforms.unix;
  };
}
