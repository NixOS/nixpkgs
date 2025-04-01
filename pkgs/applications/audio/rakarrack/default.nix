{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  alsa-utils,
  fltk,
  libjack2,
  libXft,
  libXpm,
  libjpeg,
  libpng,
  libsamplerate,
  libsndfile,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "rakarrack";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/rakarrack/${pname}-${version}.tar.bz2";
    sha256 = "1rpf63pdn54c4yg13k7cb1w1c7zsvl97c4qxcpz41c8l91xd55kn";
  };

  hardeningDisable = [ "format" ];

  patches = [
    ./fltk-path.patch
    # https://sourceforge.net/p/rakarrack/git/merge-requests/2/
    ./looper-preset.patch
  ];

  buildInputs = [
    alsa-lib
    alsa-utils
    fltk
    libjack2
    libXft
    libXpm
    libjpeg
    libpng
    libsamplerate
    libsndfile
    zlib
  ];

  meta = with lib; {
    description = "Multi-effects processor emulating a guitar effects pedalboard";
    homepage = "https://rakarrack.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
