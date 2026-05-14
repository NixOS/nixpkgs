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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ashell";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    tag = finalAttrs.version;
    hash = "sha256-X9TU866PAzaf52qKsCpeJvwE0suu1lJndHNQdPg51HM=";
  };

  cargoHash = "sha256-nhYbehlgB8pzMoj39G0BHRca9mIT+0QjUaebCx+DDE0=";

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

  meta = {
    description = "Ready to go Wayland status bar for Hyprland";
    homepage = "https://github.com/MalpenZibo/ashell";
    license = lib.licenses.mit;
    mainProgram = "ashell";
    maintainers = with lib.maintainers; [ justdeeevin ];
    platforms = lib.platforms.linux;
  };
})
