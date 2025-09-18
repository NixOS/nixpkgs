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
  sdbus-cpp_2,
  plutovg,
  lunasvg,
  nanopb,
  linalg,
  stb,
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
    hash = "sha256-CSggawgUPkpeADc8VXs5FA+ubZAtrtTu0qYgIWA0V/c=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  patches = [
    # Allow completely unvendoring hyperhdr
    # This can be removed on the next hyperhdr release
    ./unvendor.patch
  ];

  postPatch = ''
    substituteInPlace sources/sound-capture/linux/SoundCaptureLinux.cpp \
      --replace-fail "libasound.so.2" "${lib.getLib alsa-lib}/lib/libasound.so.2"
  '';

  cmakeFlags = [
    "-DPLATFORM=linux"
    (cmakeBool "USE_SYSTEM_FLATBUFFERS_LIBS" true)
    (cmakeBool "USE_SYSTEM_LUNASVG_LIBS" true)
    (cmakeBool "USE_SYSTEM_MBEDTLS_LIBS" true)
    (cmakeBool "USE_SYSTEM_MQTT_LIBS" true)
    (cmakeBool "USE_SYSTEM_NANOPB_LIBS" true)
    (cmakeBool "USE_SYSTEM_SDBUS_CPP_LIBS" true)
    (cmakeBool "USE_SYSTEM_STB_LIBS" true)
  ];

  buildInputs = [
    alsa-lib
    flatbuffers
    libjpeg_turbo
    linalg
    lunasvg
    mbedtls
    mdns
    nanopb
    pipewire
    plutovg
    qmqtt
    qt6Packages.qtbase
    qt6Packages.qtserialport
    sdbus-cpp_2
    stb
    xz
  ];

  meta = with lib; {
    description = "Highly optimized open source ambient lighting implementation based on modern digital video and audio stream analysis for Windows, macOS and Linux (x86 and Raspberry Pi / ARM";
    homepage = "https://github.com/awawa-dev/HyperHDR";
    changelog = "https://github.com/awawa-dev/HyperHDR/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      hexa
      eymeric
    ];
    mainProgram = "hyperhdr";
    platforms = platforms.linux;
  };
}
