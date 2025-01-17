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
}:
rustPlatform.buildRustPackage rec {
  pname = "ashell";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    tag = version;
    hash = "sha256-QZe67kjyHzJkZFoAOQhntYsHvvuM6L1y2wtGYTwizd4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iFg+xcdb0cMrrxmGr6VvbuD00eVknIlZeB7B7A1l4EI=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];

  runtimeDependencies = [
    wayland
    libGL
  ];

  buildInputs = [
    libpulseaudio
    rustPlatform.bindgenHook
    libxkbcommon
    pipewire
  ] ++ runtimeDependencies;

  meta = {
    description = "Ready to go Wayland status bar for Hyprland";
    homepage = "https://github.com/MalpenZibo/ashell";
    license = lib.licenses.mit;
    mainProgram = "ashell";
    maintainers = with lib.maintainers; [ justdeeevin ];
    platforms = lib.platforms.linux;
  };
}
