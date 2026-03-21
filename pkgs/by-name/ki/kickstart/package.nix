{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kickstart";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "kickstart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WrImCnXkFaPUTMBhNaUgX6PsQS1H9zj6jZ8MbgYCGCM=";
  };

  cargoHash = "sha256-Km49POZwVS2vYmELG5f7kenKQwaHlMP/bZA5cZ995mE=";

  buildFeatures = [ "cli" ];

  checkFlags = [
    # remote access
    "--skip=generation::tests::can_generate_from_remote_repo_with_subdir"
    "--skip=generation::tests::can_generate_from_remote_repo"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scaffolding tool to get new projects up and running quickly";
    homepage = "https://github.com/Keats/kickstart";
    changelog = "https://github.com/Keats/kickstart/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "kickstart";
  };
})
