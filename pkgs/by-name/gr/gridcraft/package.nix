{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  desktopToDarwinBundle,
  craft-fonts,
  versionCheckHook,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
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
  pname = "gridcraft";
  version = "0.19.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "gridcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/dkhjj+BcL/+b/psYpRdO/vEG0zpiAt5fpIqkG7WLMw=";
  };

  cargoHash = "sha256-vkNDu60fJy9GOqQSqZItees+XOmta1qB5x5ibm8nBuM=";

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  # [[patch.unused]] egui fork entries break cargo --offline.
  # The mac_menu_appkit test starts a real NSApplication, and AppKit aborts in the build
  # sandbox ("required built-in appearance SystemAppearance not found").
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm apps/gridcraft/tests/mac_menu_appkit.rs
    substituteInPlace apps/gridcraft/Cargo.toml \
      --replace-fail $'[[test]]\nname = "mac_menu_appkit"\nharness = false' ""
  '';

  cargoBuildFlags = [
    "--package=gridcraft"
    "--package=gridcraft-cli"
  ];

  # The gridcraft crate runs live GPU tests. MCP tests talk over loopback.
  cargoTestFlags = [
    "--package=gridcraft-cli"
  ];

  # apps/gridcraft-cli/tests/it/sandbox.rs (new in 0.19.x): confined-launcher tests
  # hardcode FHS paths (/usr/bin/cat, …) and need host Landlock outside the Nix sandbox.
  checkFlags = [
    "--skip=sandbox::"
  ];

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
  ]
  # Turns the desktop item into Applications/GridCraft.app.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  # On darwin, desktopToDarwinBundle builds the app icon from these.
  postInstall = ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
    install -Dm644 packaging/linux/ai.storyteller.gridcraft.desktop \
      $out/share/applications/ai.storyteller.gridcraft.desktop
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.gridcraft.mime.xml $out/share/mime/packages/ai.storyteller.gridcraft.xml
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/gridcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spreadsheet app with XLSX, CSV and TSV support";
    homepage = "https://github.com/storytold/gridcraft";
    changelog = "https://github.com/storytold/gridcraft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [
      cleboost
      sophronesis
    ];
    mainProgram = "gridcraft";
  };
})
