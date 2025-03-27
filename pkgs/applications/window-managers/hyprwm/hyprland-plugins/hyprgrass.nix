{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitHub,
  cmake,
  doctest,
  meson,
  ninja,
  wf-touch,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprgrass";
  version = "0.8.2-unstable-2025-02-01";

  src = fetchFromGitHub {
    owner = "horriblename";
    repo = "hyprgrass";
    rev = "f7017c493e071c02f203c09a63ef7260dede0586";
    hash = "sha256-F9Jnu36LXJnfDdc3mG4JYKACw/ygsPcwEbZsOdCreIQ=";
  };

  nativeBuildInputs = [
    cmake
    doctest
    meson
    ninja
  ];

  buildInputs = [ wf-touch ];

  dontUseCmakeConfigure = true;

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland plugin for touch gestures";
    homepage = "https://github.com/horriblename/hyprgrass";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
