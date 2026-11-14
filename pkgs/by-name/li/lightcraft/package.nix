{
  lib,
  stdenv,
  rustPlatform,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
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
  pname = "lightcraft";
  version = "0.21.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "lightcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2iqJCmah1bEVCxQ1VeiPWuhuHcR6U6gj6BYYUu4EcsY=";
  };

  cargoHash = "sha256-TU5eFCjfZrpUTn9r/z5EOG5axvVMz5drG8be1GHjTMI=";

  cargoBuildFlags = [
    "--package=lightcraft"
    "--package=lightcraft-cli"
  ];

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  # The `lightcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=lightcraft-cli"
  ];

  # MCP tests use loopback TCP (see soundcraft/wordcraft).
  __darwinAllowLocalNetworking = true;
  # Darwin builders lack AppKit/GPU setup for lightcraft-cli snapshot integration tests (nixpkgs-review aarch64-darwin).
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = [
    pkg-config
  ];

  # Unused egui fork patches break cargo --offline.
  # Until https://github.com/storytold/craft-libs/issues/492: startup update UI does not work on NixOS.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
    substituteInPlace apps/lightcraft/src/main.rs \
      --replace-fail 'app.set_startup_update_check(true);' 'app.set_startup_update_check(false);'
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
    install -Dm644 packaging/linux/ai.storyteller.lightcraft.desktop \
      $out/share/applications/ai.storyteller.lightcraft.desktop
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/lightcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Photo library and raw development, a native Lightroom-style editor";
    homepage = "https://github.com/storytold/lightcraft";
    changelog = "https://github.com/storytold/lightcraft/releases/tag/${finalAttrs.src.tag}";
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
    mainProgram = "lightcraft";
  };
})
