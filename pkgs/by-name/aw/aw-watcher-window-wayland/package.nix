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
  version = "0-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-watcher-window-wayland";
    rev = "aea9aca029bd33d373bf53946a16dc05ef81e0b3";
    hash = "sha256-3o3IVf2YeZ1qGokezPvuLnUaqiA/uzm4wCXvgNHIMW4=";
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
