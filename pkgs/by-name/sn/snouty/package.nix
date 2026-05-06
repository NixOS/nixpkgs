{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  podman,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snouty";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "antithesishq";
    repo = "snouty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-08F2NKPqeLcdVoD29hupmcMjwge74FRLG+tZoLYbqb8=";
  };

  cargoHash = "sha256-0u9auWAGjJNp2patIAAxQ3pI0a2w+UFRDxDv3tTBwb8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/snouty-*/out/snouty.{bash,fish} \
      --zsh $releaseDir/build/snouty-*/out/_snouty
  '';

  nativeCheckInputs = [
    podman
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for the Antithesis API";
    homepage = "https://github.com/antithesishq/snouty";
    changelog = "https://github.com/antithesishq/snouty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      carlsverre
      winter
    ];
    mainProgram = "snouty";
  };
})
