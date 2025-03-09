{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "obs-do";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    tag = "v${version}";
    hash = "sha256-4vL5v2KaE2uZ+7kVQiEivab7VBaCFXGXB+uv+3whm9s=";
  };

  cargoHash = "sha256-dM2IV5dkzz0XHJh3UGvx/3mWfqoDoYqElarD1C1v2Ro=";

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
