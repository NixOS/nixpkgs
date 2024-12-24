{
  lib,
  stdenv,
  fetchFromGitHub,
  doxygen,
  fontconfig,
  graphviz-nox,
  libxml2,
  pkg-config,
  which,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "openzwave";
  version = "1.6-unstable-2022-11-17";

  src = fetchFromGitHub {
    owner = "OpenZWave";
    repo = "open-zwave";
    rev = "3fff11d246a0d558d26110e1db6bd634a1b347c0";
    hash = "sha256-CLK2MeoTmZ8GMKb1OAZFNLyc4C+k+REK2w+WQxZv0/E=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    doxygen
    fontconfig
    graphviz-nox
    libxml2
    pkg-config
    which
  ];

  buildInputs = [ systemd ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";
  FONTCONFIG_PATH = "${fontconfig.out}/etc/fonts/";

  postPatch = ''
    substituteInPlace cpp/src/Options.cpp \
      --replace /etc/openzwave $out/etc/openzwave
    substituteInPlace cpp/build/Makefile  \
      --replace "-Werror" "-Werror -Wno-format"
  '';

  meta = with lib; {
    description = "C++ library to control Z-Wave Networks via a USB Z-Wave Controller";
    homepage = "http://www.openzwave.net/";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
