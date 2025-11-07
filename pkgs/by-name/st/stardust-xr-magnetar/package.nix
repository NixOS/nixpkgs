{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stardust-xr-magnetar";
  version = "0-unstable-2025-04-03";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "magnetar";
    rev = "63ff648bb64c23023a0047ea3ff2c0b6b1fd3caf";
    hash = "sha256-LRI3HKuOUfUb93mHB8DUpp0hvES+GbzsKAxpkLCLzKQ=";
  };

  cargoHash = "sha256-ixzasTQDVVU8cGhSW3j8ELJmmYudwfnYQEIoULLQRyo=";

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
