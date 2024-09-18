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
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "hypengw";
    repo = "Qcm";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-/FOT2xK01JbJbTd5AT5Dk/5EF9qUyLvPTnw8PMtHYoQ=";
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

  # Correct qml import path
  postInstall = ''
    mkdir $out/lib/qt-6
    mv $out/lib/qml $out/lib/qt-6/qml
  '';

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
