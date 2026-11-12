{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  versionCheckHook,
  craft-fonts,
  dbus,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  vulkan-loader,
  wayland,
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
  pname = "photocraft";
  version = "0.21.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "photocraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TjW9nhq234RDe1fbb7oElMZwKwmDY+0UBNZvqUjdgJI=";
  };

  cargoHash = "sha256-u6hM6QTbRwbiuc24hGiQRv2Wsh70Wg07yZM1IQGVyUs=";

  cargoBuildFlags = [
    "--package=photocraft"
    "--package=photocraft-cli"
  ];

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  # The `photocraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=photocraft-cli"
  ];

  # The Nix sandbox hides the memory cgroup, so upstream treats available RAM as 0
  # and refuses PSD imports (PsdImportBudget limit 0).
  checkFlags = [
    "--skip=convert_opens_a_raw_at_the_raw_defaults_resolution"
    "--skip=tiff_output_is_flat_unless_tiff_layers_is_given"
    "--skip=info_detail_adds_text_runs_and_antialiasing"
    "--skip=edited_psd_roundtrip_is_checked_and_bad_expectations_fail"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # [[patch.unused]] egui fork entries in Cargo.toml break cargo --offline in the sandbox.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.photocraft.desktop \
      $out/share/applications/ai.storyteller.photocraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.photocraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.photocraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/photocraft
    wrapProgram $out/bin/photocraft --set PHOTOCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source, native image editor with layered PSD/PSB support";
    homepage = "https://github.com/storytold/photocraft";
    changelog = "https://github.com/storytold/photocraft/releases/tag/${finalAttrs.src.tag}";
    # Bundled assets: see ATTRIBUTION.md in upstream.
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
        isc
        cc-by-30
        cc0
        bsd3
        # scowl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "photocraft";
  };
})
