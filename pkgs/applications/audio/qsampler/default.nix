{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, qttools
, liblscp, libgig, qtbase, mkDerivation }:

mkDerivation rec {
  pname = "qsampler";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${pname}-${version}.tar.gz";
    sha256 = "1wr7k739zx2nz00b810f60g9k3y92w05nfci987hw7y2sks9rd8j";
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
