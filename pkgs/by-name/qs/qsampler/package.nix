{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  qt6,
  liblscp,
  libgig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qsampler";
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
