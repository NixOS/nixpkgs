{
  cmake,
  stdenv,
  lib,
  fetchFromGitHub,
  liblsl,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "labrecorder";
  version = "1.16.5";
  src = fetchFromGitHub {
    owner = "labstreaminglayer";
    repo = "App-LabRecorder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mVDPWx3nOYCCI1QukIFwy1/vPRgVOAJaznfpQm8vtrc=";
  };
  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    liblsl
    qt6.qtbase
  ];

  postPatch = ''
    # Include LSLCMake.cmake from liblsl so the helper functions are available
    sed -i '1i include("${liblsl}/lib/cmake/lsl/LSLCMake.cmake")' CMakeLists.txt
  '';

  cmakeFlags = [
    "-DLSL_INSTALL_ROOT=${liblsl}"
    "-DCMAKE_PREFIX_PATH=${liblsl}"
  ];

  postBuild = ''
    mkdir -p $out/bin
    cp ./LabRecorder $out/bin/
    cp ./LabRecorderCLI $out/bin/
  '';

  dontInstall = true;

  meta = {
    description = "Record Lab Streaming Layer streams";
    homepage = "https://github.com/labstreaminglayer/App-LabRecorder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abcsds ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
