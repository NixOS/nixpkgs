{ stdenv, fetchurl, alsaLib, autoconf, automake, fftw, gettext, glib,
libX11, libtool, tcl, tk }:

stdenv.mkDerivation  rec {
  name = "puredata-${version}";
  version = "0.43-0";

  src = fetchurl {
    url = "mirror://sourceforge/pure-data/pd-${version}.src.tar.gz";
    sha256 = "1qfq7x8vj12kr0cdrnbvmxfhc03flicc6vcc8bz6hwrrakwciyz2";
  };

  buildInputs = [ alsaLib autoconf automake fftw gettext glib libX11
    libtool tcl tk ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = ''Real-time graphical programming environment for
                    audio, video, and graphical processing'';
    homepage = http://puredata.info;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
