{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gitMinimal,
  wrapQtAppsHook,
  perl,
  flatbuffers,
  protobuf,
  mbedtls,
  alsa-lib,
  hidapi,
  libcec,
  libftdi1,
  libusb1,
  libX11,
  libxcb,
  libXrandr,
  python3,
  qtbase,
  qtserialport,
  qtsvg,
  qtx11extras,
  qtwebsockets,
  withRPiDispmanx ? false,
  libraspberrypi,
}:

stdenv.mkDerivation rec {
  pname = "hyperion.ng";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "hyperion-project";
    repo = "hyperion.ng";
    rev = version;
    hash = "sha256-lKLXgOrXp8DLmlpQe/33A30l4K9VX8P0q2LUA+lLYws=";
    # needed for `dependencies/external/`:
    # * rpi_ws281x` - not possible to use as a "system" lib
    # * qmdnsengine - not in nixpkgs yet
    fetchSubmodules = true;
  };

  buildInputs = [
    alsa-lib
    hidapi
    libftdi1
    libusb1
    libX11
    libxcb
    libXrandr
    flatbuffers
    protobuf
    mbedtls
    python3
    qtbase
    qtserialport
    qtsvg
    qtwebsockets
    qtx11extras
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libcec
  ++ lib.optional withRPiDispmanx libraspberrypi;

  nativeBuildInputs = [
    cmake
    gitMinimal
    wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin perl; # for macos bundle

  patchPhase = ''
    patchShebangs test/testrunner.sh
    patchShebangs src/hyperiond/CMakeLists.txt
  '';

  cmakeFlags = [
    "-DENABLE_DEPLOY_DEPENDENCIES=OFF"
    "-DUSE_SYSTEM_FLATBUFFERS_LIBS=ON"
    "-DUSE_SYSTEM_LIBFTDI_LIBS=ON"
    "-DUSE_SYSTEM_MBEDTLS_LIBS=ON"
    "-DUSE_SYSTEM_PROTO_LIBS=ON"
    # "-DUSE_SYSTEM_QMDNS_LIBS=ON"  # qmdnsengine not in nixpkgs yet
    "-DENABLE_TESTS=ON"
  ]
  ++ lib.optional (withRPiDispmanx == false) "-DENABLE_DISPMANX=OFF"
  ++ lib.optional (
    stdenv.hostPlatform.system == "aarch64-linux"
  ) "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"; # required to build dependencies/external/rpi_ws281x

  doCheck = true;
  checkPhase = ''
    cd ../ && ./test/testrunner.sh && cd -
  '';

  meta = with lib; {
    description = "Opensource Bias or Ambient Lighting implementation";
    homepage = "https://github.com/hyperion-project/hyperion.ng";
    license = licenses.mit;
    maintainers = with maintainers; [
      algram
      kazenyuk
    ];
    platforms = platforms.unix;
  };
}
