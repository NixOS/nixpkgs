{
  lib,
  stdenv,
  mcpelauncher-client-qt5,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  libzip,
  curl,
  protobuf,
  qt5,
  glfw,
  apple-sdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcpelauncher-ui-qt5";
  inherit (mcpelauncher-client-qt5) version;

  src = fetchFromGitHub {
    owner = "minecraft-linux";
    repo = "mcpelauncher-ui-manifest";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+cWbuw5DtUASP+GPYygsjq5B4LyM1bfROwmtLQLx/Fw=";
  };

  patches = [
    ./dont_download_glfw_ui.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      zlib
      libzip
      curl
      protobuf
      qt5.qtbase
      qt5.qtsvg
      qt5.qtquickcontrols
      qt5.qtquickcontrols2
      qt5.qtdeclarative
      qt5.qtgraphicaleffects
      glfw
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt5.qtwebengine
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk
    ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${qt5.qtbase}")
    (lib.cmakeBool "BUILD_WEBVIEW" false)
    (lib.cmakeBool "ENABLE_WEBVIEW" false)
    (lib.cmakeBool "USE_WEBENGINE" false)
    (lib.cmakeBool "Qt5WebEngineWidgets_FOUND" false)
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-framework AppKit -framework Foundation";
  };

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export LDFLAGS="$LDFLAGS -framework AppKit -framework Foundation"
  '';

  # the program refuses to start when QT_STYLE_OVERRIDE is set
  # https://github.com/minecraft-linux/mcpelauncher-ui-qt/issues/25
  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ mcpelauncher-client-qt5 ]}
      --unset QT_STYLE_OVERRIDE
    )
  '';

  meta = mcpelauncher-client-qt5.meta // {
    description = "Unofficial Minecraft Bedrock Edition launcher with GUI (Qt5)";
    mainProgram = "mcpelauncher-ui-qt";
    platforms = lib.platforms.unix;
  };
})
