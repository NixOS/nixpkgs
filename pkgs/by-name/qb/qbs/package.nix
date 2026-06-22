{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qbs";

  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BRc5R0TsEVqImavQuIWQWv/Aknt29csmHjQq91VOY4s=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'COMPONENTS Concurrent Core Gui Network Widgets Xml' \
                     'COMPONENTS Concurrent Core CorePrivate Gui Network Widgets Xml'
  '';

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    qt6.qtdeclarative
    qt6.qttools
    qt6.qtsvg
  ];

  meta = {
    description = "Tool that helps simplify the build process for developing projects across multiple platforms";
    homepage = "https://wiki.qt.io/Qbs";
    license = lib.licenses.lgpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
