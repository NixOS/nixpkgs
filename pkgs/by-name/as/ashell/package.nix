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
rustPlatform.buildRustPackage rec {
  pname = "ashell";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    tag = version;
    hash = "sha256-1PqK+jq0ZioTluwQtEp8rpB/ZNsrvQhLgJiyIM9PQ0k=";
  };

  cargoHash = "sha256-L8RxsDxL8oyR3kz+F/NckGikfNLg+Pa1DI2nFgHL5VM=";

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
  ++ runtimeDependencies;

  meta = {
    description = "Ready to go Wayland status bar for Hyprland";
    homepage = "https://github.com/MalpenZibo/ashell";
    license = lib.licenses.mit;
    mainProgram = "ashell";
    maintainers = with lib.maintainers; [ justdeeevin ];
    platforms = lib.platforms.linux;
  };
}
