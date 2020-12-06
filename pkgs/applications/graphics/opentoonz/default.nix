{ boost, cmake, fetchFromGitHub, freeglut, freetype, glew, libjpeg, libmypaint
, libpng, libtiff, libusb1, lz4, lzma, lzo, openblas, pkgconfig, qtbase
, qtmultimedia, qtscript, stdenv, superlu, wrapQtAppsHook, }:
let source = import ./source.nix { inherit fetchFromGitHub; };
in stdenv.mkDerivation rec {
  inherit (source) src;

  pname = "opentoonz";
  version = source.versions.opentoonz;

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];

  buildInputs = [
    boost
    freeglut
    freetype
    glew
    libjpeg
    libmypaint
    libpng
    libtiff
    libusb1
    lz4
    lzma
    lzo
    openblas
    qtbase
    qtmultimedia
    qtscript
    superlu
  ];

  postUnpack = "sourceRoot=$sourceRoot/toonz";

  cmakeDir = "../sources";
  cmakeFlags = [
    "-DTIFF_INCLUDE_DIR=${libtiff.dev}/include"
    "-DTIFF_LIBRARY=${libtiff.out}/lib/libtiff.so"
  ];

  postInstall = ''
    sed -i '/cp -r .*stuff/a\    chmod -R u+w $HOME/.config/OpenToonz/stuff' $out/bin/opentoonz
  '';

  meta = {
    description = "Full-featured 2D animation creation software";
    homepage = "https://opentoonz.github.io/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ chkno ];
  };
}
