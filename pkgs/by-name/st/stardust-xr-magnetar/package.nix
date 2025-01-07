{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-magnetar";
  version = "0-unstable-2024-08-31";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "magnetar";
    rev = "48064b84b71d27ceea00b5d2f19dcbf21d75f554";
    hash = "sha256-x1yHf5ceCws4C8NuoB/+kHwZK09vnn4IOFgduhjl4O8=";
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
