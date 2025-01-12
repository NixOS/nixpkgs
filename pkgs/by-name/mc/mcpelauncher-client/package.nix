{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchpatch,
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
}:

# gcc doesn't support __has_feature
clangStdenv.mkDerivation (finalAttrs: {
  pname = "mcpelauncher-client";
  version = "1.1.2-qt6";

  # NOTE: check mcpelauncher-ui-qt when updating
  src = fetchFromGitHub {
    owner = "minecraft-linux";
    repo = "mcpelauncher-manifest";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-PmCq6Zgtp17UV0kIbNouFwj/DMiTqwE31+tTb2LUp5o=";
  };

  patches = [
    ./dont_download_glfw_client.patch
    # These are upcoming changes that have been merged upstream. Once these get in a release, remove these patches.
    (fetchpatch {
      url = "https://github.com/minecraft-linux/game-window/commit/feea8c0e0720eea7093ed95745c17f36d6c40671.diff";
      hash = "sha256-u4uveoKwwklEooT+i+M9kZ0PshjL1IfWhlltmulsQJo=";
      stripLen = 1;
      extraPrefix = "game-window/";
    })
    (fetchpatch {
      url = "https://github.com/minecraft-linux/mcpelauncher-client/commit/db9c31e46d7367867c85a0d0aba42c8144cdf795.diff";
      hash = "sha256-za/9oZYwKCYyZ1BXQ/zeEjRy81B1NpTlPHEfWAOtzHk=";
      stripLen = 1;
      extraPrefix = "mcpelauncher-client/";
    })
  ];

  # FORTIFY_SOURCE breaks libc_shim and the project will fail to compile
  hardeningDisable = [ "fortify" ];

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals (withQtWebview || withQtErrorWindow) [
      qt6.wrapQtAppsHook
    ];

  buildInputs =
    [
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
