{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "clorinde";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "halcyonnouveau";
    repo = "clorinde";
    tag = "clorinde-v${version}";
    hash = "sha256-Nqf0NNjE3gu+75tjMKAY3Wn75PiPwpnXgXtzdhqx7u8=";
  };

  cargoHash = "sha256-OLA9n7MBN5Fz3D3MJLb6PoEksO5Da2mp5h8pti2/lpA=";

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
