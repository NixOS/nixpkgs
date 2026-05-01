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
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "imagineer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pnnMRRccxSA5F6oIbe9wvdMmuSUMI7Da+NtwyH2psjo=";
  };

  cargoHash = "sha256-6QMMP6Uss9r6zNd/S6w7yo19IBOQyLmFvcn2o0MkOq4=";

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
