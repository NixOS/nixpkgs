{
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  stdenv,
  # Package dependencies
  qt6,
  libusb1,
  protobuf,
  asio,
}:

stdenv.mkDerivation rec {
  pname = "hidviz";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hidviz";
    repo = "hidviz";
    rev = "v${version}";
    hash = "sha256-ThDDQ3FN+cLCbdQCrC5zhL4dgg2zAbRWvtei7+qmQg8=";
  };

  preConfigure = ''
    substituteInPlace libhidx/cmake_modules/Findasio.cmake --replace-fail '/usr/include/asio' '${lib.getDev asio}/include/asio'
    substituteInPlace libhidx/libhidx/src/Connector.cc --replace-fail '/usr/local/libexec' "$out/libexec"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtwebengine
    libusb1
    protobuf
    asio
  ];

  meta = with lib; {
    homepage = "https://github.com/hidviz/hidviz";
    description = "GUI application for in-depth analysis of USB HID class devices";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
