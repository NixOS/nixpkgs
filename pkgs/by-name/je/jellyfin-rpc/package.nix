{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-rpc";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Radiicall";
    repo = "jellyfin-rpc";
    tag = version;
    hash = "sha256-RZ4G8/gMD2HsNdCJyr1PTKySGcv45a57KAEqAvLBtjQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-olg36uXAXVe3BuAqMAlLyokoeDm9wVLfE45tKuGlWF8=";

  # TODO: Re-enable when upstream bumps the version number internally
  # nativeInstallCheckInputs = [
  #   versionCheckHook
  # ];
  # doInstallCheck = true;

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
