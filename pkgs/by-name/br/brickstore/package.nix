{
  lib,
  stdenv,
  qt6,
  qt6Packages,
  fetchFromGitHub,
  gst_all_1,
  cmake,
  libglvnd,
  onetbb,
  ninja,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "brickstore";
  version = "2026.3.2";

  src = fetchFromGitHub {
    owner = "rgriebl";
    repo = "brickstore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UIVzvzsterKkL8/JPx5S0wly6mLxflAqX0gMFX3rOes=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libglvnd
    ninja
    pkg-config
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
    qt6Packages.qcoro
    onetbb
  ];

  # Use nix-provided qcoro instead of fetching from GitHub
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'include(BuildQCoro)' \
        'find_package(QCoro6 CONFIG REQUIRED COMPONENTS Core Network Qml)'
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
