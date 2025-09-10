{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  nix-update-script,
}:

let
  version = "0.6.0";
in
rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-IZ2tyQzWa2Uk002P9jCiaIV3huRiFdTe8eYXVQPBBJI=";
  };

  cargoHash = "sha256-ExQPCA8sAZVE5uB1KUnq6PXGhG1IZjzM9eFwYW3oJtE=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Systemd unit switcher for Home Manager";
    mainProgram = "sd-switch";
    homepage = "https://git.sr.ht/~rycee/sd-switch";
    changelog = "https://git.sr.ht/~rycee/sd-switch/refs/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rycee ];
    platforms = lib.platforms.linux;
  };
}
