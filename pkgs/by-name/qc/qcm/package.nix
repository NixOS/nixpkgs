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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "hypengw";
    repo = "Qcm";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-fdqmtS1lKHbsgsDmmlNOV1q2C0u+jCNC0aouImw3/y8=";
  };

  patches = [
    ./remove_cubeb_vendor.patch
    # fix: 'std::strong_ordering operator<=>(const QString&, const QString&)'
    # in core/include/core/qstr_helper.h
    # duplicate with qtbase-6.8.0/include/QtCore/qstring.h
    ./remove_redefinition_operator.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
    curl
    ffmpeg
    cubeb
  ] ++ cubeb.passthru.backendLibs;

  # Correct qml import path
  postInstall = ''
    mv $out/lib/qt6 $out/lib/qt-6
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
