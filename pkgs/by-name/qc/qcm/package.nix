{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, qt6
, curl
, ffmpeg
, cubeb
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qcm";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "hypengw";
    repo = "Qcm";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-dwzstlmGuY8oRxxO2BPXmSCSnE7Fbp+dyYVs17HUopA=";
  };

  patches = [ ./remove_cubeb_vendor.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    curl
    ffmpeg
    cubeb
  ] ++ cubeb.passthru.backendLibs;

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath cubeb.passthru.backendLibs}"
  ];

  meta = {
    description = "Unofficial Qt client for netease cloud music";
    homepage = "https://github.com/hypengw/Qcm";
    license = lib.licenses.gpl2Plus;
    mainProgram = "Qcm";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
