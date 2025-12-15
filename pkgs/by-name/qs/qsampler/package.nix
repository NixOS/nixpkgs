{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  pkg-config,
  liblscp,
  libgig,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qsampler";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/qsampler-${finalAttrs.version}.tar.gz";
    sha256 = "1wr7k739zx2nz00b810f60g9k3y92w05nfci987hw7y2sks9rd8j";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    liblscp
    libgig
    libsForQt5.qtbase
  ];

  preConfigure = "make -f Makefile.svn";

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.linuxsampler.org";
    description = "Graphical frontend to LinuxSampler";
    mainProgram = "qsampler";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
