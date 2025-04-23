{
  lib,
  stdenv,
  mcpelauncher-client,
  fetchFromGitHub,
  fetchpatch,
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
    hash = "sha256-333PwfBWhdfJSi1XrJNHidMYZrzSReb8s4VxBASFQ6Q=";
  };

  patches = [
    ./dont_download_glfw_ui.patch
    # Qt 6.9 no longer implicitly converts non-char types (such as booleans) to
    # construct a QChar. This leads to a build failure with Qt 6.9. Upstream
    # has merged a patch, but has not yet formalized it through a release, so
    # we must fetch it manually. Remove this fetch on the next point release.
    (fetchpatch {
      url = "https://github.com/minecraft-linux/mcpelauncher-ui-qt/commit/0526b1fd6234d84f63b216bf0797463f41d2bea0.diff";
      hash = "sha256-vL5iqbs50qVh4BKDxTOpCwFQWO2gLeqrVLfnpeB6Yp8=";
      stripLen = 1;
      extraPrefix = "mcpelauncher-ui-qt/";
    })
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
