{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-do";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "obs-do";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GDCz6PfRf1dhVzBTHoVyctkWduQiGcMpGHRg/EbiImU=";
  };

  cargoHash = "sha256-28t4sKSjVn+Ao7cbdmSjQbj2E/CZ4eTeoH4Tj9YRlo8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
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
