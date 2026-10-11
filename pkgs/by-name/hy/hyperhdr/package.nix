{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  autoAddDriverRunpath,
  alsa-lib,
  flatbuffers,
  libglvnd,
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
  inherit (lib) cmakeBool;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "hyperhdr";
  version = "22.0.0.0";

  src = fetchFromGitHub {
    owner = "awawa-dev";
    repo = "HyperHDR";
    tag = "v${finalAttrs.version}";
    hash = "sha256-si39Q5XaZHGAFEU2sqU60+5kPYVPnTAoPaiyWD1Dlvs=";
  };

  nativeBuildInputs = [
    autoAddDriverRunpath
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace cmake/installer_linux.cmake \
      --replace-fail 'DESTINATION "/usr/lib/systemd/system"' 'DESTINATION "lib/systemd/system"'

    # CMAKE_INSTALL_LIBDIR is an absolute store path in Nix builds, but HyperHDR
    # constructs this RPATH as if it were relative to $ORIGIN.
    substituteInPlace sources/hyperhdr/CMakeLists.txt \
      --replace-fail 'set(rpath_libs_dir "$ORIGIN/../''${CMAKE_INSTALL_LIBDIR}/hyperhdr")' 'set(rpath_libs_dir "$ORIGIN/../lib/hyperhdr")'

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

  # The PipeWire plugin loads EGL dynamically via dlopen().
  # Keep libglvnd reachable independently of the runtime driver libraries.
  postFixup = ''
    patchelf --add-rpath "${libglvnd}/lib" "$out/lib/hyperhdr/libsmart-pipewire.so"
  '';

  buildInputs = [
    alsa-lib
    flatbuffers
    libglvnd
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

  meta = {
    description = "Highly optimized open source ambient lighting implementation based on modern digital video and audio stream analysis for Windows, macOS and Linux (x86 and Raspberry Pi / ARM";
    homepage = "https://github.com/awawa-dev/HyperHDR";
    changelog = "https://github.com/awawa-dev/HyperHDR/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      eymeric
    ];
    mainProgram = "hyperhdr";
    platforms = lib.platforms.linux;
  };
})
