{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nasm,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "imagineer";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "imagineer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Joqw/PECC5h1WoAEce8R6DlgLAhh2suqphDxJfwVz0o=";
  };

  cargoHash = "sha256-S5T+V9d9TVuOK2K/4DSUK2/ufenko+8Gw37wG4HeYS4=";

  nativeBuildInputs = [
    installShellFiles
    nasm
  ];

  postBuild = ''
    cargo run --example gen_completions
  '';

  postInstall = ''
    installShellCompletion ig.{bash,fish}
    installShellCompletion --zsh _ig
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Accessible image processing and conversion from the terminal";
    homepage = "https://github.com/foresterre/sic";
    changelog = "https://github.com/foresterre/sic/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "ig";
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
