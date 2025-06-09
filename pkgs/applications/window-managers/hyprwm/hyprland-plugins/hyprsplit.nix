{
  lib,
  meson,
  fetchFromGitHub,
  hyprland,
  ninja,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin hyprland rec {
  pluginName = "hyprsplit";
  version = "0.48.1-unstable-2025-05-03";

  src = fetchFromGitHub {
    owner = "shezdy";
    repo = "hyprsplit";
    rev = "9a65a4d33cc86703d2ac1f349de9697c8fc7a4b9";
    hash = "sha256-NJTCUa8kHXzQDpUmSifXrHMheR5yejigG2vPBepHolA=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/shezdy/hyprsplit";
    description = "Hyprland plugin for awesome / dwm like workspaces";
    license = lib.licenses.bsd3;
    inherit (hyprland.meta) platforms;
    maintainers = with lib.maintainers; [
      aacebedo
    ];
  };
}
