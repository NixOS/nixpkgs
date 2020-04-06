{
  alsaLib,
  boost,
  cln,
  cmake,
  fetchFromGitHub,
  gcc,
  ginac,
  jamomacore,
  kdnssd,
  libsndfile,
  ninja,
  portaudio,
  portmidi,
  qtbase,
  qtdeclarative,
  qtimageformats,
  qtmultimedia,
  qtquickcontrols2,
  qtserialport,
  qtsvg,
  qttools,
  qtwebsockets,
  rtaudio,
  stdenv
}:

stdenv.mkDerivation rec {
  version = "1.0.0-b31";
  pname = "i-score";

  src = fetchFromGitHub {
    owner = "OSSIA";
    repo = "i-score";
    rev = "v${version}";
    sha256 = "0g7s6n11w3wflrv5i2047dxx56lryms7xj0mznnlk5bii7g8dxzb";
    fetchSubmodules = true;
  };

  buildInputs = [
    alsaLib
    boost
    cln
    cmake
    ginac
    gcc
    jamomacore
    kdnssd
    libsndfile
    ninja
    portaudio
    portmidi
    qtbase
    qtdeclarative
    qtimageformats
    qtmultimedia
    qtquickcontrols2
    qtserialport
    qtsvg
    qttools
    qtwebsockets
    rtaudio
  ];

  cmakeFlags = [
    "-GNinja"
    "-DISCORE_CONFIGURATION=static-release"
    "-DISCORE_ENABLE_LTO=OFF"
    "-DISCORE_BUILD_FOR_PACKAGE_MANAGER=True"
  ];

  preConfigure = ''
    export CMAKE_PREFIX_PATH="''${CMAKE_PREFIX_PATH-}:$(echo "${jamomacore}/jamoma/share/cmake/Jamoma")"
  '';

  postInstall = ''rm $out/bin/i-score.sh'';

  meta = {
    description = "An interactive sequencer for the intermedia arts";
    homepage = http://i-score.org/;
    license = stdenv.lib.licenses.cecill20;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
