{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "inori";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "eshrh";
    repo = "inori";
    tag = "v${version}";
    hash = "sha256-w+UsG4CHdug6TITJLjhHsQeAhHenzDFnZLICDT0Z1UM=";
  };

  cargoHash = "sha256-AvYNeWyitoi9hDqiy5hl/VM4LO8J2xmLgl0y8P4xYNA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client for the Music Player Daemon (MPD)";
    homepage = "https://github.com/eshrh/inori";
    changelog = "https://github.com/eshrh/inori/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "inori";
    maintainers = with lib.maintainers; [
      stephen-huan
      esrh
    ];
  };
}
