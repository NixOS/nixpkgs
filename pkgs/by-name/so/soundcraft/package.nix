{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  desktopToDarwinBundle,
  alsa-lib,
  libx11,
  libxcb,
  libGL,
  libxkbcommon,
  nix-update-script,
  wayland,
  libxcursor,
  libxi,
  vulkan-loader,
  dbus,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "soundcraft";
  version = "0.20.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "soundcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qew1WjgKWQ58OPZrhHVZRlKkj7u1EjwP9fgEOjKwfkw=";
  };

  cargoHash = "sha256-rZzO2+VoVp/1nE/fHQ8hqsu7sFEVQX1AFMsPUOjRIK8=";

  # Unused egui fork entries break cargo --offline.
  # Leave egui_extras: it is a real workspace.dependencies entry.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
    substituteInPlace apps/soundcraft/src/main.rs \
      --replace-fail 'app.set_startup_update_check(true);' 'app.set_startup_update_check(false);'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    alsa-lib
    libx11
    libxcb
    libGL
    libxkbcommon
    wayland
    # dlopened at runtime by winit/x11-dl, x11rb (dl-libxcb), xkbcommon-dl, wgpu and
    # g-desktop-portal; the fork's libx11 also ships libX11-xcb.so.1 in the same dir.
    libxcursor
    libxi
    vulkan-loader
    dbus
  ];

  # The clap-host/engine integration tests spawn a nested `cargo build` for an out-of-workspace
  # fixture cdylib and expect its artefacts at target/debug/..., which does not hold up under
  # the sandboxed, release-profile nix check environment.
  doCheck = false;

  cargoBuildFlags = [
    "-p"
    "soundcraft"
    "-p"
    "soundcraft-cli"
  ];

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.soundcraft.desktop \
      $out/share/applications/ai.storyteller.soundcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.soundcraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.soundcraft.xml

    # Install under the hicolor theme and publish an index.theme; without one, GTK/KDE icon
    # lookups cannot see the icons (upstream ships no index.theme).
    install -d $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons
  '';

  postFixup = ''
    patchelf --set-rpath "${
      lib.makeLibraryPath [
        alsa-lib
        libx11
        libxcb
        libGL
        libxkbcommon
        wayland
        libxcursor
        libxi
        vulkan-loader
        dbus
      ]
    }" \
      $out/bin/soundcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SoundCraft desktop app";
    homepage = "https://github.com/storytold/soundcraft";
    changelog = "https://github.com/storytold/soundcraft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    mainProgram = "soundcraft";
    maintainers = with lib.maintainers; [
      gaelj
    ];
  };
})
