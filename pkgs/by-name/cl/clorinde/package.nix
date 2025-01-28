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

  useFetchCargoVendor = true;
  cargoHash = "sha256-ssyx72o/eTcFClLyl4QJ71okqKU2k6SZVH0eGEFzIjs=";

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
