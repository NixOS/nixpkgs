{
  lib,
  clangStdenv,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zlib,
  libpng,
  libglvnd,
  xorg,
  libevdev,
  curl,
  pulseaudio,
  qt6,
  glfw,
  withQtWebview ? true,
  withQtErrorWindow ? true,
  fetchzip,
  zenity,
  xdg-utils,
  sdl3,
}:

# Bionic libc part doesn't compile with GCC
clangStdenv.mkDerivation (finalAttrs: {
  pname = "mcpelauncher-client";
  version = "1.4.0-qt6";

  # NOTE: check mcpelauncher-ui-qt when updating
  src = fetchFromGitHub {
    owner = "minecraft-linux";
    repo = "mcpelauncher-manifest";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-2YmsxcR4EipnBIBqoM8g6hOCCh1WKooukqXhP/1X6tU=";
  };

  patches = [ ./dont_download_glfw_client.patch ];

  # Path hard-coded paths.
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace mcpelauncher-client/src/jni/main_activity.cpp \
      --replace-fail /usr/bin/xdg-open ${xdg-utils}/bin/xdg-open \
      --replace-fail /usr/bin/zenity ${lib.getExe zenity}

    substituteInPlace file-picker/src/file_picker_zenity.cpp \
      --replace-fail 'EXECUTABLE_NAME = "zenity"' 'EXECUTABLE_NAME = "${lib.getExe zenity}"'
  '';

  # FORTIFY_SOURCE breaks libc_shim and the project will fail to compile
  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals (withQtWebview || withQtErrorWindow) [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    zlib
    libpng
    libglvnd
    xorg.libX11
    xorg.libXi
    xorg.libXtst
    libevdev
    curl
    pulseaudio
    glfw
    sdl3
  ]
  ++ lib.optionals (withQtWebview || withQtErrorWindow) [
    qt6.qtbase
    qt6.qttools
    qt6.qtwayland
  ]
  ++ lib.optionals withQtWebview [
    qt6.qtwebengine
  ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON_EXT" (
      toString (fetchzip {
        url = "https://github.com/nlohmann/json/releases/download/v3.7.3/include.zip";
        hash = "sha256-h8czZ4f5vZqvHkDVQawrQdUeQnWxewu4OONisqlrmmM=";
        stripRoot = false;
      })
    ))
    (lib.cmakeBool "USE_OWN_CURL" false)
    (lib.cmakeBool "ENABLE_DEV_PATHS" false)
    (lib.cmakeFeature "GAMEWINDOW_SYSTEM" "GLFW")
    (lib.cmakeBool "USE_SDL3_AUDIO" false)
    (lib.cmakeBool "BUILD_WEBVIEW" withQtWebview)
    (lib.cmakeBool "XAL_WEBVIEW_USE_CLI" (!withQtWebview))
    (lib.cmakeBool "XAL_WEBVIEW_USE_QT" withQtWebview)
    (lib.cmakeBool "ENABLE_QT_ERROR_UI" withQtErrorWindow)
  ];

  meta = {
    description = "Unofficial Minecraft Bedrock Edition launcher with CLI";
    homepage = "https://minecraft-linux.github.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aleksana
      morxemplum
      phanirithvij
    ];
    mainProgram = "mcpelauncher-client";
    platforms = lib.platforms.unix;
    # Minecraft Bedrock Edition is raising minimal OpenGL version to OpenGL ES 3.1
    # which is currently not supported on macOS.
    # https://github.com/minecraft-linux/mcpelauncher-manifest/issues/1042
    # https://help.minecraft.net/hc/en-us/articles/30298767427597-Upcoming-OS-Sunset-Announcements-in-Minecraft
    # The program is also not tested on darwin. Any help from darwin users are welcomed.
    badPlatforms = lib.platforms.darwin;
  };
})
