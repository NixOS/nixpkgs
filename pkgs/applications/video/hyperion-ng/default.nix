{ stdenv, lib, fetchFromGitHub
, cmake, wrapQtAppsHook, perl
, flatbuffers, protobuf, mbedtls
, alsa-lib, hidapi, libcec, libusb1
, libX11, libxcb, libXrandr, python3
, qtbase, qtserialport, qtsvg, qtx11extras
, withRPiDispmanx ? false, libraspberrypi
}:

stdenv.mkDerivation rec {
  pname = "hyperion.ng";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "hyperion-project";
    repo = pname;
    rev = version;
    hash = "sha256-nQPtJw9DOKMPGI5trxZxpP+z2PYsbRKqOQEyaGzvmmA=";
    # needed for `dependencies/external/`:
    # * rpi_ws281x` - not possible to use as a "system" lib
    # * qmdnsengine - not in nixpkgs yet
    fetchSubmodules = true;
  };

  buildInputs = [
    alsa-lib
    hidapi
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
    qtx11extras
  ] ++ lib.optional stdenv.hostPlatform.isLinux libcec
    ++ lib.optional withRPiDispmanx libraspberrypi;

  nativeBuildInputs = [
    cmake wrapQtAppsHook
  ] ++ lib.optional stdenv.hostPlatform.isDarwin perl; # for macos bundle

  patchPhase =  ''
    patchShebangs test/testrunner.sh
    patchShebangs src/hyperiond/CMakeLists.txt
  '' ;

  cmakeFlags = [
    "-DENABLE_DEPLOY_DEPENDENCIES=OFF"
    "-DUSE_SYSTEM_FLATBUFFERS_LIBS=ON"
    "-DUSE_SYSTEM_PROTO_LIBS=ON"
    "-DUSE_SYSTEM_MBEDTLS_LIBS=ON"
    # "-DUSE_SYSTEM_QMDNS_LIBS=ON"  # qmdnsengine not in nixpkgs yet
    "-DENABLE_TESTS=ON"
  ] ++ lib.optional (withRPiDispmanx == false) "-DENABLE_DISPMANX=OFF";

  doCheck = true;
  checkPhase = ''
    cd ../ && ./test/testrunner.sh && cd -
  '';

  meta = with lib; {
    description = "Opensource Bias or Ambient Lighting implementation";
    homepage = "https://github.com/hyperion-project/hyperion.ng";
    license = licenses.mit;
    maintainers = with maintainers; [ algram kazenyuk ];
    platforms = platforms.unix;
  };
}
