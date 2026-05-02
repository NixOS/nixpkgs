{
  cmake,
  stdenv,
  lib,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  liblsl,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "labrecorder";
  version = "1.17.1";
  src = fetchFromGitHub {
    owner = "labstreaminglayer";
    repo = "App-LabRecorder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HXgkopaeJR6KftJHq/o+m2g8UXts3+8kI2l8mGIHJIk=";
  };
  nativeBuildInputs = [
    cmake
    copyDesktopItems
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

  desktopItems = [
    (makeDesktopItem {
      name = "labrecorder";
      exec = "LabRecorder";
      desktopName = "LabRecorder";
      genericName = "Lab Streaming Layer recorder";
      comment = "Record Lab Streaming Layer streams";
      categories = [ "Science" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./LabRecorder    $out/bin/LabRecorder
    install -Dm755 ./LabRecorderCLI $out/bin/LabRecorderCLI

    runHook postInstall
  '';

  meta = {
    description = "Record Lab Streaming Layer streams";
    homepage = "https://github.com/labstreaminglayer/App-LabRecorder";
    license = lib.licenses.mit;
    mainProgram = "LabRecorder";
    maintainers = with lib.maintainers; [ abcsds ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
