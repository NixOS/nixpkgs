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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    tag = finalAttrs.version;
    hash = "sha256-QRNEc2HNqA1tZk/jW/MXDwXda58yNlkw86SCTjH1/1w=";
  };

  cargoHash = "sha256-bLZcRASBGV9Y/QlDVBdOl2ElZDLI1KUAh5MlOsjmlKs=";

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
