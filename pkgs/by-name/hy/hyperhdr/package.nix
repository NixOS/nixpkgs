{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  sdbus-cpp_2,
}:

let
  inherit (lib)
    cmakeBool
    ;
in

stdenv.mkDerivation rec {
  pname = "hyperhdr";
  version = "21.0.0.0";

  src = fetchFromGitHub {
    owner = "awawa-dev";
    repo = "HyperHDR";
    tag = "v${version}";
    hash = "sha256-S4in3fVjbkPfQe7ubuoUJ6AKha2luSjZPFS55aSo2jU=";
    fetchSubmodules = true;
    deepClone = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  patches = [
    # https://github.com/awawa-dev/HyperHDR/pull/1140
    # This can be removed on next release
    (fetchpatch {
      name = "USE_SYSTEM_SDBUS_CPP_LIBS";
      url = "https://github.com/awawa-dev/HyperHDR/pull/1140.patch";
      hash = "sha256-Fuog++K3qaDeC/HymLPl5RF0yolNFL891EY4f36ILwE=";
    })
  ];

  cmakeFlags = [
    "-DPLATFORM=linux"
    (cmakeBool "USE_SYSTEM_SDBUS_CPP_LIBS" true)
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
    sdbus-cpp_2
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
