{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-magnetar";
  version = "0-unstable-2024-12-29";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "magnetar";
    rev = "d00c5ecf0bcaf2b4382ec3b4f3373ea5b761ee7b";
    hash = "sha256-2I6BRjw5t68OMc93cis4/qnyYT9OBYIr1S+ZF8LmFCc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "stardust-xr-0.45.0" = "sha256-WF/uNtFYB+ZQqsyXJe7qUCd8SHUgaNOLMxGuNIN1iKM=";
      "stardust-xr-molecules-0.45.0" = "sha256-NncLa5ApFtlxy/BF08vy4mw2zor02VsGPaVI4arMaqM=";
    };
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Workspaces client for Stardust";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "magnetar";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
