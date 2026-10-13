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
  version = "0-unstable-2026-06-29";

  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-watcher-window-wayland";
    rev = "24aecc62973a0bae784c7c4f3e179a50c989892b";
    hash = "sha256-LJ+8snTq/l1Pstw686jxNSFaq3hXloWtODgh7+YsdwU=";
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
