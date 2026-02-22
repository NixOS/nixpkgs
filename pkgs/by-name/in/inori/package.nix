{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inori";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "eshrh";
    repo = "inori";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U1fNLqJYtTJK0WZ0sO7DADVDRPSik5vuE78zGnJt15A=";
  };

  cargoHash = "sha256-EfRSFxu/F+ltkx3uQ353CRlMrZN4PbmFdcw7H9Tm3ss=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client for the Music Player Daemon (MPD)";
    homepage = "https://github.com/eshrh/inori";
    changelog = "https://github.com/eshrh/inori/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "inori";
    maintainers = with lib.maintainers; [
      stephen-huan
      esrh
    ];
  };
})
