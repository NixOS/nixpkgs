{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, qttools
, liblscp, libgig, qtbase }:

stdenv.mkDerivation rec {
  pname = "qsampler";
  version = "0.5.6";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${pname}-${version}.tar.gz";
    sha256 = "0lx2mzyajmjckwfvgf8p8bahzpj0n0lflyip41jk32nwd2hzjhbs";
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
