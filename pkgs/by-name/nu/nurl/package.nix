{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  gitMinimal,
  mercurial,
  nix,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nurl";
  version = "0.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nurl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mtMKiMwG23XWcjL9dPOeoGX0MWxIj3M1QdVaKeEioSA=";
  };

  cargoHash = "sha256-Lk2beX9/KjNtFpJuu6bA7qnChJjggRR1ZFGajG/s/w4=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  # disable tests that require internet access
  checkFlags = [
    "--skip=integration"
    "--skip=verify_outputs"
  ];

  postInstall = ''
    wrapProgram $out/bin/nurl \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
          mercurial
          nix
        ]
      }
    installManPage artifacts/nurl.1
    installShellCompletion artifacts/nurl.{bash,fish} --zsh artifacts/_nurl
  '';

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command-line tool to generate Nix fetcher calls from repository URLs";
    homepage = "https://github.com/nix-community/nurl";
    changelog = "https://github.com/nix-community/nurl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      figsoda
      matthiasbeyer
    ];
    mainProgram = "nurl";
  };
})
