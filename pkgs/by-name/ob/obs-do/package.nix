{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-do";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BYZI8XirNon7P2ckyXaLkFiU4OuwK2y9eLccj0D/2W4=";
  };

  cargoHash = "sha256-V5j+zi7ogwxs2kCMRjDD7pF8yBWE6p7J2UAOXeJGbFw=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
})
