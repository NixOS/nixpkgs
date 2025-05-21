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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "MalpenZibo";
    repo = "ashell";
    tag = version;
    hash = "sha256-J97MRYYkNx8Ze4vcxZTDVOSQLCANyIBcDtqZEsEZ80w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XDcCCKq/NOzaKTDwVu0GCeGV70IlJ2TvD0w8ib+lEhg=";

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
