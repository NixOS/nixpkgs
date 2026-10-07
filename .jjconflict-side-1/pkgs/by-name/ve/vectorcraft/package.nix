{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  copyDesktopItems,
  makeDesktopItem,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  craft-fonts,

  nix-update-script,
}:

let
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
    libxrandr
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vectorcraft";
  version = "0.17.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "vectorcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5kfG3C6aKii2ov0j9N8K44LFiEY261saNSmJzvbyLhU=";
  };

  cargoHash = "sha256-WtoC67BVtmNh0YFsDXVVrXV9qcdFYkSC2VBJ/zZlACo=";

  cargoBuildFlags = [
    "--package=vectorcraft"
    "--package=vectorcraft-cli"
  ];

  # The `vectorcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=vectorcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.vectorcraft";
      desktopName = "VectorCraft";
      genericName = "Vector Graphics Editor";
      comment = "Draw and edit vector illustrations, SVG and PDF";
      exec = "vectorcraft %F";
      tryExec = "vectorcraft";
      icon = "ai.storyteller.vectorcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.vectorcraft";
      keywords = [
        "vector"
        "illustration"
        "svg"
        "pdf"
        "drawing"
        "bezier"
      ];
      mimeTypes = [
        "image/svg+xml"
        "application/pdf"
        "application/x-vectorcraft"
        "image/svg+xml-compressed"
        "application/illustrator"
        "application/x-ai-template"
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/tiff"
        "image/bmp"
        "application/x-vectorcraft-template"
        "image/vnd.dxf"
        "image/emf"
        "image/wmf"
        "image/x-eps"
        "application/x-affinity"
      ];
      categories = [
        "Graphics"
        "2DGraphics"
        "VectorGraphics"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.vectorcraft.mime.xml $out/share/mime/packages/ai.storyteller.vectorcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/vectorcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector illustration, a native Illustrator-style editor for SVG and PDF";
    homepage = "https://github.com/storytold/vectorcraft";
    changelog = "https://github.com/storytold/vectorcraft/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "vectorcraft";
    platforms = rustc.meta.platforms;
  };
})
