{
  lib,
  stdenv,
  mcpelauncher-client,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  libzip,
  curl,
  protobuf,
  qt6,
  glfw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcpelauncher-ui-qt";
  inherit (mcpelauncher-client) version;

  src = fetchFromGitHub {
    owner = "minecraft-linux";
    repo = "mcpelauncher-ui-manifest";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-R9wE1lS7x1IIPgVahXjF5Yg2ca+GsiQuF41pWf2edXY=";
  };

  patches = [
    ./dont_download_glfw_ui.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    libzip
    curl
    protobuf
    qt6.qtwebengine
    qt6.qtsvg
    qt6.qtwayland
    glfw
  ];

  # the program refuses to start when QT_STYLE_OVERRIDE is set
  # https://github.com/minecraft-linux/mcpelauncher-ui-qt/issues/25
  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ mcpelauncher-client ]}
      --unset QT_STYLE_OVERRIDE
    )
  '';

  meta = mcpelauncher-client.meta // {
    description = "Unofficial Minecraft Bedrock Edition launcher with GUI";
    mainProgram = "mcpelauncher-ui-qt";
  };
})
