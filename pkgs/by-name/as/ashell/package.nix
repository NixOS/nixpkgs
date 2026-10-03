{
  fetchFromGitHub,
  lib,
  rustPlatform,
  autoPatchelfHook,
  pkg-config,
  libxkbcommon,
  libGL,
  pipewire,
  libpulseaudio,
  wayland,
  udev,
  vulkan-loader,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ashell";
  version = "4";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    tag = finalAttrs.version;
    hash = "sha256-EtPsUcdMxZ4CARvQ7lnmpLo6N6yNcPbQLPdd2j/Ng7w=";
  };

  cargoHash = "sha256-qr3OtQjMU+9yxIWL6sIAcNeOoq/32zcDY8UX0D/4x+I=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    rustPlatform.bindgenHook
  ];

  runtimeDependencies = [
    wayland
    libGL
    vulkan-loader
  ];

  buildInputs = [
    libpulseaudio
    libxkbcommon
    pipewire
    udev
  ]
  ++ finalAttrs.runtimeDependencies;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ready to go Wayland status bar for Hyprland";
    homepage = "https://github.com/MalpenZibo/ashell";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ashell";
    maintainers = with lib.maintainers; [ justdeeevin ];
    platforms = lib.platforms.linux;
  };
})
