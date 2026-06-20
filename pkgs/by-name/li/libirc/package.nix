{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation {
  pname = "libirc";
  version = "0-unstable-2025-11-09";

  src = fetchFromGitHub {
    owner = "grumpy-irc";
    repo = "libirc";
    rev = "59c6d81242910d8205b94acadf54cec0d2313884";
    hash = "sha256-C7bO2Dwa6p7/bUh73JJCup2biIm9UShOUSxL9uCShqg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true; # library only

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail 'cmake_minimum_required(VERSION 3.0)' 'cmake_minimum_required(VERSION 3.10)'
  '';

  cmakeFlags = [
    (lib.cmakeBool "QT6_BUILD" true)
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17") # supposedly required for Qt
  ];

  preFixup = ''
    mkdir -p $out/libirc/libirc{,client}
    cp ../libirc/*.h $out/libirc/libirc
    cp ../libircclient/*.h $out/libirc/libircclient
  '';

  meta = {
    description = "C++ IRC library written in Qt with support for data serialization";
    homepage = "https://github.com/grumpy-irc/libirc";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ fee1-dead ];
    platforms = lib.platforms.linux;
  };
}
