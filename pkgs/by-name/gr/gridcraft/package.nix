{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  desktopToDarwinBundle,
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
  version = "0.13.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "gridcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L1kbIku3WX/7pU/DpTqy2A2yT/+7vQVoK+iUYf5Dkpk=";
  };

  cargoHash = "sha256-gudikEONztiu7cfkt87CTIydKQEfPNgvRBTobzXz3qM=";

  # The mac_menu_appkit test starts a real NSApplication, and AppKit aborts in the build
  # sandbox ("required built-in appearance SystemAppearance not found").
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm apps/gridcraft/tests/mac_menu_appkit.rs
    substituteInPlace apps/gridcraft/Cargo.toml \
      --replace-fail $'[[test]]\nname = "mac_menu_appkit"\nharness = false' ""
  '';

  cargoBuildFlags = [
    "--package=gridcraft"
    "--package=gridcraft-cli"
  ];

  # The gridcraft-mcp tests talk to a fake app over a loopback TCP socket.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    patchelf
  ]
  # Turns the desktop item into Applications/GridCraft.app.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  # On darwin, desktopToDarwinBundle builds the app icon from these.
  postInstall = ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
    install -Dm644 packaging/linux/ai.storyteller.gridcraft.desktop \
      $out/share/applications/
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
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "gridcraft";
    platforms = rustc.meta.platforms;
  };
})
