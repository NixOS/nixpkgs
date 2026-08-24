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
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/qsampler/qsampler-${finalAttrs.version}.tar.gz";
    hash = "sha256-z+rSHQD/HpEdpGpYqNoMXRUPnmmav5qORcLel43Ahk8=";
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
