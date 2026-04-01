{
  lib,
  cmake,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "hy3";
  version = "0.54.2";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    tag = "hl${finalAttrs.version}";
    hash = "sha256-ceT6njnsCLefWhn5C6FYdp68Te9UfcQLAaYIHGjt8bk=";
  };

  nativeBuildInputs = [ cmake ];

  dontStrip = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "hl(.*)"
    ];
  };

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
})
