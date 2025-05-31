{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4-layer-shell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprswitch";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprswitch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k3mxR4xp+BLwc75cM3t3K1WA1TCSULzowUsu5ISnfdY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8+p3K1kAahMExNUV5AX7jDJzmEVvPsy83JyEY6yskh0=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    gtk4-layer-shell
  ];

  meta = {
    description = "CLI/GUI that allows switching between windows in Hyprland";
    mainProgram = "hyprswitch";
    homepage = "https://github.com/H3rmt/hyprswitch";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ arminius-smh ];
  };
})
