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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    tag = version;
    hash = "sha256-a0yvmAq/4TDe+W1FLeLPSLppX81G6fdAOhzDmDJg3II=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Vh/+4iApi+03ZmMIDSXc9Mn408v3wC+WlNJsXNcva+Q=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    rustPlatform.bindgenHook
  ];

  runtimeDependencies = [
    wayland
    libGL
  ];

  buildInputs = [
    libpulseaudio
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
