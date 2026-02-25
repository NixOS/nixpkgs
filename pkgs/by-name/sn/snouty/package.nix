{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snouty";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "antithesishq";
    repo = "snouty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bOMD8Bn/L/YGaxXmsK0G0nTo32FHPJaXOWK3VcPXeo8=";
  };

  cargoHash = "sha256-q4MoB34iwuBfmnP1xKSIS1vy5LJ4rW0YHmMZuEYEDwY=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/snouty-*/out/snouty.{bash,fish} \
      --zsh $releaseDir/build/snouty-*/out/_snouty
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "CLI for the Antithesis API";
    homepage = "https://github.com/antithesishq/snouty";
    changelog = "https://github.com/antithesishq/snouty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      carlsverre
    ];
    mainProgram = "snouty";
  };
})
