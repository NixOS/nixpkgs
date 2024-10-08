{
  lib,
  meson,
  fetchFromGitHub,
  hyprland,
  ninja,
  mkHyprlandPlugin,
}:
mkHyprlandPlugin hyprland rec {
  pluginName = "hyprsplit";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "shezdy";
    repo = "hyprsplit";
    rev = "refs/tags/v${version}";
    hash = "sha256-r533kNIyfgPi/q8ddIYyDK1Pmupt/F3ncHuFo3zjDkU=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

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
