{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, qttools
, liblscp, libgig, qtbase }:

stdenv.mkDerivation rec {
  name = "qsampler-${version}";
  version = "0.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${name}.tar.gz";
    sha256 = "1wg19022gyzy8rk9npfav9kz9z2qicqwwb2x5jz5hshzf3npx1fi";
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
