{ stdenv, fetchsvn, alsaLib, autoconf, automake, gtk, jackaudio,
libgnomecanvas, libsamplerate, libsndfile, libtool, libxml2, phat,
pkgconfig }:

stdenv.mkDerivation  rec {
  name = "specimen-svn-89";

  # The released version won't compile with newer versions of jack
  src = fetchsvn {
    url = http://zhevny.com/svn/specimen/trunk;
    rev = 89;
    sha256 = "1i24nchw14cbjv7kmzs7cvmis2xv4r7bxghi8d6gq5lprwk8xydf";
  };

  preConfigure = "sh autogen.sh";

  buildInputs = [ alsaLib autoconf automake gtk jackaudio
    libgnomecanvas libsamplerate libsndfile libtool libxml2 phat
    pkgconfig ];

  meta = with stdenv.lib; {
    description = "MIDI controllable audio sampler";
    homepage = http://zhevny.com/specimen/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
