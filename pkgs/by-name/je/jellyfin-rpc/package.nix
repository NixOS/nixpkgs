{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-rpc";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Radiicall";
    repo = "jellyfin-rpc";
    tag = version;
    hash = "sha256-cEHJJXMfXKDPKah2wDAdcO0SXO4ZPL/SqFbxONmI57M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CWl/hVtwv2Q4/GwJJGTHCxnMxj8ZR9wPmLTlai0MyBA=";

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
