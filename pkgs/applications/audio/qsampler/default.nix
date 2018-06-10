{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, qttools
, liblscp, libgig, qtbase }:

stdenv.mkDerivation rec {
  name = "qsampler-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${name}.tar.gz";
    sha256 = "18j4cwmn7waih9x5b66cba2aa85spqqp507bf19ahsb5gl358yhh";
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
