{
  lib,
  stdenv,
  qt6,
  libsForQt5,
  fetchFromGitHub,
  gst_all_1,
  cmake,
  libglvnd,
  tbb,
  ninja,
  pkg-config,
}:
let
  inherit (libsForQt5) qcoro;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "brickstore";
  version = "2024.5.2";

  src = fetchFromGitHub {
    owner = "rgriebl";
    repo = "brickstore";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bu9oNbZm3lx/CfYAReHyWe/kW+kaefDWeBtWLHOCORU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libglvnd
    ninja
    pkg-config
    qcoro
    qt6.qtdoc
    qt6.qtdeclarative
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtquick3d
    qt6.qtquicktimeline
    qt6.qtshadertools
    qt6.qttools
    qt6.qtwayland
    qt6.wrapQtAppsHook
    tbb
  ];

  preConfigure = ''
    sed -i '/^)$/d' cmake/BuildQCoro.cmake

    substituteInPlace cmake/BuildQCoro.cmake \
      --replace-fail 'FetchContent_Declare(' ' ' \
      --replace-fail '    qcoro' ' ' \
      --replace-fail '    GIT_REPOSITORY https://github.com/danvratil/qcoro.git' ' ' \
      --replace-fail '    GIT_TAG        v''${QCORO_VERSION}' ' ' \
      --replace-fail 'FetchContent_GetProperties(qcoro)' ' ' \
      --replace-fail 'FetchContent_Populate(qcoro)' ' ' \
      --replace-fail \
        'add_subdirectory(''${qcoro_SOURCE_DIR} ''${qcoro_BINARY_DIR} EXCLUDE_FROM_ALL)' \
        'add_subdirectory(${qcoro.src} ${qcoro}bin/qcoro)'
  '';

  qtWrapperArgs = [
    ''
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${
        lib.makeLibraryPath [
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-libav
        ]
      }
    ''
  ];

  meta = {
    changelog = "https://github.com/rgriebl/brickstore/blob/main/CHANGELOG.md";
    description = "BrickLink offline management tool";
    homepage = "https://www.brickstore.dev/";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      BrickStore is a BrickLink offline management tool.
      It is multi-platform (Windows, macOS and Linux as well as iOS and Android),
      multilingual (currently English, German, Spanish, Swedish and French), fast and stable.
    '';
    maintainers = with lib.maintainers; [ legojames ];
    mainProgram = "brickstore";
    platforms = lib.platforms.linux;
  };
})
