{ stdenv, fetchurl, alsaLib, cmake, gtk2, libjack2, libgnomecanvas
, libpthreadstubs, libsamplerate, libsndfile, libtool, libxml2
, pkgconfig, openssl }:

stdenv.mkDerivation  rec {
  pname = "petri-foo";
  version = "0.1.87";

  src = fetchurl {
    url =  "mirror://sourceforge/petri-foo/${pname}-${version}.tar.bz2";
    sha256 = "0b25iicgn8c42487fdw32ycfrll1pm2zjgy5djvgw6mfcaa4gizh";
  };

  buildInputs =
   [ alsaLib cmake gtk2 libjack2 libgnomecanvas libpthreadstubs
     libsamplerate libsndfile libtool libxml2 pkgconfig openssl
   ];

  meta = with stdenv.lib; {
    description = "MIDI controllable audio sampler";
    longDescription = "a fork of Specimen";
    homepage = "http://petri-foo.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
