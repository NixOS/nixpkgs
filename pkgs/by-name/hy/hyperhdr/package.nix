{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  flatbuffers,
  libjpeg_turbo,
  mbedtls,
  mdns,
  pipewire,
  qt6Packages,
  qmqtt,
  xz,
}:

let
  inherit (lib)
    cmakeBool
    ;
in

stdenv.mkDerivation rec {
  pname = "hyperhdr";
  version = "20.0.0.0";

  src = fetchFromGitHub {
    owner = "awawa-dev";
    repo = "HyperHDR";
    rev = "refs/tags/v${version}";
    hash = "sha256-agIWtDlMwjD0sGX2ntFwqROzUsl8tY3nRbmFvvOVh4o=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DPLATFORM=linux"
    (cmakeBool "USE_SYSTEM_MQTT_LIBS" true)
    (cmakeBool "USE_SYSTEM_FLATBUFFERS_LIBS" true)
    (cmakeBool "USE_SYSTEM_MBEDTLS_LIBS" true)
  ];

  buildInputs = [
    alsa-lib
    flatbuffers
    libjpeg_turbo
    mdns
    mbedtls
    pipewire
    qmqtt
    qt6Packages.qtbase
    qt6Packages.qtserialport
    xz
  ];

  meta = with lib; {
    description = "Highly optimized open source ambient lighting implementation based on modern digital video and audio stream analysis for Windows, macOS and Linux (x86 and Raspberry Pi / ARM";
    homepage = "https://github.com/awawa-dev/HyperHDR";
    changelog = "https://github.com/awawa-dev/HyperHDR/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "hyperhdr";
    platforms = platforms.linux;
  };
}
