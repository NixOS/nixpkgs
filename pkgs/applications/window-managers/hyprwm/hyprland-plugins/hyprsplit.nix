{
  lib,
  meson,
  fetchFromGitHub,
  ninja,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprsplit";
  version = "0.54.3-unstable-2026-06-11";

  src = fetchFromGitHub {
    owner = "shezdy";
    repo = "hyprsplit";
    rev = "6b00b677d8905fb38779c91e12d6294e0e586a44";
    hash = "sha256-PaoUtmk+qIP/ESdxkxnY7mUMpMHjix88qu22R5GLQqE=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/shezdy/hyprsplit";
    description = "Hyprland plugin for awesome / dwm like workspaces";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      aacebedo
      mrdev023
    ];
  };
})
