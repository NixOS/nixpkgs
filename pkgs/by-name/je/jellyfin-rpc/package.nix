{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-rpc";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "Radiicall";
    repo = "jellyfin-rpc";
    tag = version;
    hash = "sha256-g4Vd++Q6rJS6nU1kR+7aItnhHc0jeFSU460iF6P1EEk=";
  };

  cargoHash = "sha256-ltEm3hFiHBM4NtYg1qrFH26jMDgWa+al06P6O/Su1XA=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Displays the content you're currently watching on Discord";
    homepage = "https://github.com/Radiicall/jellyfin-rpc";
    changelog = "https://github.com/Radiicall/jellyfin-rpc/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "jellyfin-rpc";
  };
}
