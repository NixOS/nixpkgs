{
  lib,
  cmake,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
}:
mkHyprlandPlugin hyprland rec {
  pluginName = "hy3";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    rev = "refs/tags/hl${version}";
    hash = "sha256-6TVaB+nWVanqZWqievg+m7tVNrSpQ9CQcwXJQeyU/Q0=";
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
