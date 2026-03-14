{
  lib,
  fetchFromGitHub,
  rustPlatform,
  typst,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mitex";
  version = "0.2.6-unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "mitex-rs";
    repo = "mitex";
    rev = "0680e50c6e768f99ffe382801a4d7316af75b42f";
    hash = "sha256-ejS9GHX65gr9fJeZLi7dQN0Lb47DOGMKUhL9Pq+Latw=";
  };

  cargoHash = "sha256-AKQrIehctDlG06R21Ia14IC7Yj2/mq/VKPOyIdDBS2g=";

  nativeBuildInputs = [ typst ];

  cargoBuildFlags = [
    "-p mitex-cli"
    "--features generate-spec"
  ];

  cargoTestFlags = [ "-p mitex-cli" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "LaTeX support for Typst, CLI for Mitex";
    homepage = "https://mitex-rs.github.io/mitex/";
    downloadPage = "https://github.com/mitex-rs/mitex";
    maintainers = with lib.maintainers; [ chillcicada ];
    license = lib.licenses.asl20;
    mainProgram = "mitex";
  };
})
