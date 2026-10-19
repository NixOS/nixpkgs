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
  # Loaded with dlopen by winit, wgpu and rfd (libdbus, for the file dialogs).
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "figcraft";
  version = "0.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "figcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0K9K3EEe/HKpufzW8ym9NUwsNpioUvPUxV9rxpoJU2Q=";
  };

  cargoHash = "sha256-BdDJmIoTAH06y+bvfY8WyzxgV7572oxSdkA8kN4wz4E=";

  cargoBuildFlags = [
    "--package=figcraft"
    "--package=figcraft-cli"
  ];

  # The `figcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=figcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.figcraft";
      desktopName = "FigCraft";
      genericName = "Interface Design Tool";
      comment = "Design and prototype user interfaces";
      exec = "figcraft %U";
      tryExec = "figcraft";
      icon = "ai.storyteller.figcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.figcraft";
      keywords = [
        "design"
        "interface"
        "ui"
        "ux"
        "prototype"
        "wireframe"
        "mockup"
        "vector"
        "layout"
        "components"
      ];
      mimeTypes = [
        "application/x-figcraft"
        "image/jpeg"
        "image/png"
        "image/svg+xml"
        "x-scheme-handler/figcraft"
      ];
      categories = [
        "Graphics"
        "2DGraphics"
        "VectorGraphics"
        "X-Design"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.figcraft.mime.xml $out/share/mime/packages/ai.storyteller.figcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/figcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interface design and prototyping, a native Figma-style editor";
    homepage = "https://github.com/storytold/figcraft";
    changelog = "https://github.com/storytold/figcraft/releases/tag/v${finalAttrs.version}";
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
    mainProgram = "figcraft";
    platforms = rustc.meta.platforms;
  };
})
