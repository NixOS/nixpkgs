{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inotify-tools";
  version = "4.26.287";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "inotify-tools";
    rev = finalAttrs.version;
    hash = "sha256-nO5dDURftIWpvdE6XCLwCI3gKL+lY/x/efOyGRLmYgE=";
  };

  cargoHash = "sha256-KPbnEx2QmHBHMpwrT6MJkjfKldWqEEfiLDiHlbiGMD4=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/inotify-tools/inotify-tools/wiki";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pSub
    ];
    platforms = lib.platforms.linux;
  };
})
