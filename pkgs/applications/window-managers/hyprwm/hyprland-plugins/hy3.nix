{
  lib,
  cmake,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
}:
mkHyprlandPlugin hyprland rec {
  pluginName = "hy3";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    rev = "refs/tags/hl${version}";
    hash = "sha256-hBvwaMlgBuR2cB1Kx6cA1z7x38HXUujNcHtBsKhaEZs=";
  };

  nativeBuildInputs = [ cmake ];

  dontStrip = true;

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
