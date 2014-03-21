{ stdenv, fetchsvn, autoconf, automake, liblscp, libtool, pkgconfig
, qt4 }:

stdenv.mkDerivation rec {
  name = "qsampler-svn-${version}";
  version = "2342";

  src = fetchsvn {
    url = "https://svn.linuxsampler.org/svn/qsampler/trunk";
    rev = "${version}";
    sha256 = "17w3vgpgfmvl11wsd5ndk9zdggl3gbzv3wbd45dyf2al4i0miqnx";
  };

  buildInputs = [ autoconf automake liblscp libtool pkgconfig qt4 ];

  preConfigure = "make -f Makefile.svn";

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "graphical frontend to LinuxSampler";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
