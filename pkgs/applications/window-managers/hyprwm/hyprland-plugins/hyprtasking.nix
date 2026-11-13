{
  lib,
  meson,
  fetchFromGitHub,
  ninja,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprtasking";
  version = "0-unstable-2026-09-20";

  src = fetchFromGitHub {
    owner = "raybbian";
    repo = "hyprtasking";
    rev = "12d1c68c5b9cc6ca169403cf4fde067fd78bbf62";
    hash = "sha256-2K6YGGahYJVepvoUkKjHHW1Yr0izKwyoN30CDwoZYNw=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/raybbian/hyprtasking";
    description = "Powerful workspace management plugin for Hyprland";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rachalaraj ];
  };
})
