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
  version = "0-unstable-2024-10-08";

  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-watcher-window-wayland";
    rev = "58bf86a6984cb01fa750c84ce468c7ccb167f796";
    hash = "sha256-SnlShM44jnQiZGg5mjreZg1bsjFLNYMjC/krR1TXTE4=";
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
