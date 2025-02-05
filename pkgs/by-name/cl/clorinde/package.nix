{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "clorinde";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "halcyonnouveau";
    repo = "clorinde";
    tag = "clorinde-v${version}";
    hash = "sha256-03lKEAPJTxIXLNF2jVuD6DHJDqTkqCt1Vc+A1/E1CP4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-a/MH1jG3w7zgUQnlLRtZyn+MM7vdlydq/u4XSGPGgSA=";

  cargoBuildFlags = [ "--package=clorinde" ];

  cargoTestFlags = cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "clorinde-v(.*)"
    ];
  };

  meta = {
    description = "Generate type-checked Rust from your PostgreSQL";
    homepage = "https://github.com/halcyonnouveau/clorinde";
    changelog = "https://github.com/halcyonnouveau/clorinde/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "clorinde";
  };
}
