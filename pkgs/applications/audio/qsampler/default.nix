{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, qttools
, liblscp, libgig, qtbase }:

stdenv.mkDerivation rec {
  name = "qsampler-${version}";
  version = "0.5.5";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${name}.tar.gz";
    sha256 = "1li2p8zknrdr62wlaassfvgski0rlbr3lvrzywbh32dq8j50w8zf";
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
