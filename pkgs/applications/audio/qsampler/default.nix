{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, qttools
, liblscp, libgig, qtbase }:

stdenv.mkDerivation rec {
  name = "qsampler-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${name}.tar.gz";
    sha256 = "0kn1mv31ygjjsric03pkbv7r8kg3bri9ldx2ajc9pyx0p8ggnbmc";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig qttools ];
  buildInputs = [ liblscp libgig qtbase ];

  preConfigure = "make -f Makefile.svn";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "Graphical frontend to LinuxSampler";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
