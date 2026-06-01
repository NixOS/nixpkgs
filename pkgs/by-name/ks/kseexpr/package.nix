{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  qt6,
  kdePackages,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kseexpr";
  version = "6.0.0.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "kseexpr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z3CjQdKHeZ/6He43qVYQj8Fo0y88v/ldJJD8bPYOaEo=";
  };

  patches = [
    # see https://github.com/NixOS/nixpkgs/issues/144170
    ./cmake_libdir.patch
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  dontWrapQtApps = true;

  buildInputs = [
    bison
    flex
    kdePackages.ki18n
    qt6.qtbase
    qt6.qttools
  ];

  meta = {
    homepage = "https://invent.kde.org/graphics/kseexpr";
    description = "Embeddable expression evaluation engine";
    maintainers = [ ];
    license = lib.licenses.lgpl3Plus;
  };
})
