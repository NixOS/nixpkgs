{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  qt5,
  libsForQt5,
  bison,
  flex,
  llvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kseexpr";
  version = "4.0.4.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "kseexpr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XjFGAN7kK2b0bLouYG3OhajhOQk4AgC4EQRzseccGCE=";
  };
  patches = [
    # see https://github.com/NixOS/nixpkgs/issues/144170
    ./cmake_libdir.patch
  ];
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    bison
    flex
    libsForQt5.ki18n
    llvm
    qt5.qtbase
  ];

  meta = {
    homepage = "https://invent.kde.org/graphics/kseexpr";
    description = "Embeddable expression evaluation engine";
    maintainers = with lib.maintainers; [ nek0 ];
    license = lib.licenses.lgpl3Plus;
  };
})
