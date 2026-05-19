{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  unstableGitUpdater,
  wayland,
}:
rustPlatform.buildRustPackage {
  pname = "aw-watcher-window-wayland";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-watcher-window-wayland";
    rev = "c14e6fbaf1b811a46ec6b5c27d8656f0976a1850";
    hash = "sha256-U1tFdglzO5YcGPfzVAprol8bdQ1mO7OP1Q6gShG/fbk=";
  };

  cargoHash = "sha256-WWT8tOrHPf5x3bXsVPt32VKut4qK+K8gickBfEc0zmk=";

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    wayland
  ];

  meta = {
    description = "WIP window and afk watcher for some Wayland compositors";
    homepage = "https://github.com/ActivityWatch/aw-watcher-window-wayland";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ esau79p ];
    mainProgram = "aw-watcher-window-wayland";
    platforms = lib.platforms.linux;
  };
}
