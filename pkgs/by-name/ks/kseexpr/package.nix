{ stdenv, lib
, fetchFromGitLab
, sd
, cmake
, qt5
, libsForQt5
, bison, flex, llvm, extra-cmake-modules
}:


stdenv.mkDerivation rec {
  pname = "kseexpr";
  version = "4.0.4.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XjFGAN7kK2b0bLouYG3OhajhOQk4AgC4EQRzseccGCE=";
  };
  patches = [
    # see https://github.com/NixOS/nixpkgs/issues/144170
    ./cmake_libdir.patch
  ];
  buildInputs = [
    qt5.qtbase
    bison flex llvm libsForQt5.ki18n
  ];
  nativeBuildInputs = [ cmake qt5.wrapQtAppsHook extra-cmake-modules ];
  meta = with lib; {
    homepage    = "https://invent.kde.org/graphics/kseexpr";
    description = "An embeddable expression evaluation engine";
    maintainers = with maintainers; [ nek0 ];
    license     = licenses.lgpl3Plus;
  };
}
