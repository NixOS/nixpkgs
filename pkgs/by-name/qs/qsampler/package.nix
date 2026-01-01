{
  lib,
  stdenv,
  fetchurl,
<<<<<<< HEAD
  cmake,
  pkg-config,
  qt6,
  liblscp,
  libgig,
=======
  autoconf,
  automake,
  libtool,
  pkg-config,
  liblscp,
  libgig,
  libsForQt5,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qsampler";
<<<<<<< HEAD
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/qsampler-${finalAttrs.version}.tar.gz";
    hash = "sha256-cvdnVE3FmsgLy5s6N2nX+2fM4Nyri+rUaxQQeWGluxo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    liblscp
    qt6.qtbase
  ];

  qtWrapperArgs = [ "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libgig ]}" ];

  meta = {
    homepage = "https://qsampler.sourceforge.io";
    description = "LinuxSampler GUI front-end application";
    mainProgram = "qsampler";
    license = lib.licenses.gpl2Plus;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
