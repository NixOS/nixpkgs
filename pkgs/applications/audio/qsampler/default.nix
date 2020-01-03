{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, qttools
, liblscp, libgig, qtbase, mkDerivation }:

mkDerivation rec {
  pname = "qsampler";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${pname}-${version}.tar.gz";
    sha256 = "1krhjyd67hvnv6sgndwq81lfvnb4qkhc7da1119fn2lzl7hx9wh3";
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
