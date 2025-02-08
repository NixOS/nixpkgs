{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "clorinde";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "halcyonnouveau";
    repo = "clorinde";
    tag = "clorinde-v${version}";
    hash = "sha256-p91LgbRj2+acOrmNuupIR92Z5aOJnTobVDd7A6ezrHk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Vo7Ho+48QJEeAm+eLTCvB/4Q6/YoE0KbbfvdC2WictY=";

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
