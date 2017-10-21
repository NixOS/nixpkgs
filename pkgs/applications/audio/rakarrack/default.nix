{ stdenv, fetchurl, alsaLib, alsaUtils, fltk, libjack2, libXft,
libXpm, libjpeg, libpng, libsamplerate, libsndfile, zlib }:

stdenv.mkDerivation  rec {
  name = "rakarrack-${version}";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/rakarrack/${name}.tar.bz2";
    sha256 = "1rpf63pdn54c4yg13k7cb1w1c7zsvl97c4qxcpz41c8l91xd55kn";
  };

  hardeningDisable = [ "format" ];

  patches = [ ./fltk-path.patch ];

  buildInputs = [ alsaLib alsaUtils fltk libjack2 libXft libXpm libjpeg
    libpng libsamplerate libsndfile zlib ];

  meta = with stdenv.lib; {
    description = "Multi-effects processor emulating a guitar effects pedalboard";
    homepage = http://rakarrack.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
