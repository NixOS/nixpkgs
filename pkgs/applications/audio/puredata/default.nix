{ stdenv, fetchurl, alsaLib, autoconf, automake, fftw, gettext, glib
, jackaudio, libX11, libtool, makeWrapper, pkgconfig, tcl, tk
}:

stdenv.mkDerivation  rec {
  name = "puredata-${version}";
  version = "0.44-0";

  src = fetchurl {
    url = "mirror://sourceforge/pure-data/pd-${version}.src.tar.gz";
    sha256 = "031bvqfnlpfx0y5n0l5rmslziqc6jgmk99x1prgh1rmhjhjdnijw";
  };

  buildInputs = [
    alsaLib autoconf automake fftw gettext glib jackaudio libX11
    libtool makeWrapper pkgconfig tcl tk
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  postInstall = ''
    wrapProgram $out/bin/pd --prefix PATH : ${tk}/bin
  '';

  meta = with stdenv.lib; {
    description = ''A real-time graphical programming environment for
                    audio, video, and graphical processing'';
    homepage = http://puredata.info;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
