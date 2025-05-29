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

stdenv.mkDerivation rec {
  pname = "kseexpr";
  version = "4.0.4.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "kseexpr";
    rev = "v${version}";
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

  meta = with lib; {
    homepage = "https://invent.kde.org/graphics/kseexpr";
    description = "Embeddable expression evaluation engine";
    maintainers = with maintainers; [ nek0 ];
    license = licenses.lgpl3Plus;
  };
}
