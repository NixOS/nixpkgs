{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  writableTmpDirAsHomeHook,
  podman,
  docker-compose,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snouty";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "antithesishq";
    repo = "snouty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RUSYb5og2onduZ/FkSQn4PvcOYb6sm2HPKt14Is1K0g=";
  };

  cargoHash = "sha256-x7BHcMkbt9130T5Wwv/ujtp8+3cw9RcOroCafQZwFlQ=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd snouty \
      --bash <($out/bin/snouty completions bash) \
      --fish <($out/bin/snouty completions fish) \
      --zsh <($out/bin/snouty completions zsh)
  '';

  useNextest = true;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    podman
    docker-compose
    gitMinimal
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

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
