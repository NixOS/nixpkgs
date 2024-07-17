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
  version = "4.2.05";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-rBGJ+63Szhy37LQw0LpE2/lLyP5lwK7hsz/uq453iHY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
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
    ++ lib.optionals (stdenv.isLinux) [
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
