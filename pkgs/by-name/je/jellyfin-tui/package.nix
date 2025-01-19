{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  mpv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-tui";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "dhonus";
    repo = "jellyfin-tui";
    tag = "v${version}";
    hash = "sha256-dME3oM3k5TGjN8S/93Crt3vw8+KjZWivkVzg+eqwfe4=";
  };

  cargoHash = "sha256-DFwEcKPc5c+xYas/gI3dHGRW8r4B8GBRXiI9VjdMrpw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    mpv
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jellyfin music streaming client for the terminal";
    mainProgram = "jellyfin-tui";
    homepage = "https://github.com/dhonus/jellyfin-tui";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ GKHWB ];
  };
}
