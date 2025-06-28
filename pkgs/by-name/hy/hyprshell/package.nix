{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  hyprland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprshell";
  version = "4.2.13";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OgIeNlD2YcW5lWAQvqMvOphIxbIpGOL2WNQmtAGCsbQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/f1AzpuzhVLeSbemgpXkh/ag33bsRMg3lrRPKVGOcK8=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  meta = {
    description = "Modern GTK4-based window switcher and application launcher for Hyprland";
    mainProgram = "hyprshell";
    homepage = "https://github.com/H3rmt/hyprshell";
    license = lib.licenses.mit;
    platforms = hyprland.meta.platforms;
    maintainers = with lib.maintainers; [ arminius-smh ];
  };
})
