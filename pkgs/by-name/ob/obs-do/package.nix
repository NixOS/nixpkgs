{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "obs-do";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    tag = "v${version}";
    hash = "sha256-t6m/PX4GMCFH9wFrOaU/dcrbKitUXQlOcU7aUyJPpxA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gy/r8s4LF6LDeI+hz0ddAOTcaDh8Uvz9vF4Eg/+1q1Q=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI for common OBS operations while streaming using WebSocket";
    homepage = "https://github.com/jonhoo/obs-do";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "obs-do";
  };
}
