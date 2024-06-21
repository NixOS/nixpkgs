{
  lib,
  cmake,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
}:
mkHyprlandPlugin hyprland rec {
  pluginName = "hy3";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    rev = "hl${version}";
    hash = "sha256-gEEWWlQRvejSR2RRg78Lubz6siIgknqj6CslveyyIP4=";
  };

  nativeBuildInputs = [ cmake ];

  dontStrip = true;

  meta = {
    homepage = "https://github.com/outfoxxed/hy3";
    description = "Hyprland plugin for an i3 / sway like manual tiling layout";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aacebedo ];
  };
}
