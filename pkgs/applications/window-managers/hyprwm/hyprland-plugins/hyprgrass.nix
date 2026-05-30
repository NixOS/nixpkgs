{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  cmake,
  doctest,
  meson,
  ninja,
  wf-touch,
  nix-update-script,
}:

mkHyprlandPlugin {
  pluginName = "hyprgrass";
  version = "0.8.2-unstable-2026-05-18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "horriblename";
    repo = "hyprgrass";
    rev = "c9968ba79b3537eff127d6ab6df767d76f17544a";
    hash = "sha256-rVLdIs67in1fhaatayWrLu+kCOJ0cveKze/BRjYtxRw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    meson
    ninja
  ];

  buildInputs = [
    doctest
    wf-touch
  ];

  dontUseCmakeConfigure = true;

  doCheck = true;

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland plugin for touch gestures";
    homepage = "https://github.com/horriblename/hyprgrass";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
