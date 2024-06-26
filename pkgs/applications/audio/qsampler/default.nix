{
  lib,
  fetchurl,
  autoconf,
  automake,
  libtool,
  pkg-config,
  qttools,
  liblscp,
  libgig,
  qtbase,
  mkDerivation,
}:

mkDerivation rec {
  pname = "qsampler";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/${pname}-${version}.tar.gz";
    sha256 = "1wr7k739zx2nz00b810f60g9k3y92w05nfci987hw7y2sks9rd8j";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    qttools
  ];
  buildInputs = [
    liblscp
    libgig
    qtbase
  ];

  preConfigure = "make -f Makefile.svn";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.linuxsampler.org";
    description = "Graphical frontend to LinuxSampler";
    mainProgram = "qsampler";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
