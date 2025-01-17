{
  lib,
  cmake,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin hyprland rec {
  pluginName = "hy3";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    rev = "refs/tags/hl${version}";
    hash = "sha256-b3PuEtRHTSxV809RLUiZVQhDQZ8NxxpWUjboTe9QAAY=";
  };

  nativeBuildInputs = [ cmake ];

  dontStrip = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/outfoxxed/hy3";
    description = "Hyprland plugin for an i3 / sway like manual tiling layout";
    license = lib.licenses.gpl3;
    inherit (hyprland.meta) platforms;
    maintainers = with lib.maintainers; [
      aacebedo
      johnrtitor
    ];
  };
}
