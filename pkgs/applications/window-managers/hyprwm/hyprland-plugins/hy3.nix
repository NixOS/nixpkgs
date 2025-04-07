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
  version = "hl0.48.0";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    tag = version;
    hash = "sha256-CUlxc2u1Y8gpeAl7NKrZxxpeZjyU2DBxOYb8b0haM2M=";
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
