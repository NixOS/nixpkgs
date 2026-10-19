{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
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
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "figcraft";
  version = "0.15.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "figcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E3DdHHgJVdebbXqibZcrhytT0aDUUc+a+kpTUZocBK0=";
  };

  cargoHash = "sha256-c33mZKKmttDf9jIhmm43bRguGnwQyXhhjg+tC1Ibk4o=";

  # [[patch.unused]] egui fork entries in Cargo.toml break cargo --offline in the sandbox.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider|egui_kittest) = /d' Cargo.toml

    # Until https://github.com/storytold/craft-libs/issues/492: startup update UI does not work on NixOS.
    substituteInPlace apps/figcraft/src/main.rs \
      --replace-fail 'fig.set_startup_update_check(true);' 'fig.set_startup_update_check(false);'
  '';

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
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.figcraft.desktop \
      $out/share/applications/ai.storyteller.figcraft.desktop
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
    changelog = "https://github.com/storytold/figcraft/releases/tag/${finalAttrs.src.tag}";
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
