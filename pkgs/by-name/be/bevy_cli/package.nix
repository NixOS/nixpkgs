{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  pkg-config,
  openssl,
  cargo-generate,
  binaryen,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bevy_cli";
  version = "0.1.0-alpha.2";

  src = fetchFromGitHub {
    owner = "TheBevyFlock";
    repo = "bevy_cli";
    tag = "cli-v${finalAttrs.version}";
    hash = "sha256-FGUmUPWgrAKTijKBiFqh6AfFPHONWCd80SzF/t1g4go=";
  };

  cargoHash = "sha256-rOaJzU48/C4hqygQFYKPiYXKzxBa+SrGNpOZVYCEGOE=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
  ];

  buildInputs = [ openssl ];

  checkFlags = [
    # This unit tests rely on specific environment
    "--skip=config::tests::merge_rustflags::merge_empty_native_cli_config"
    "--skip=config::tests::merge_rustflags::merge_native_cli_config"

    # Integration tests require access to dependencies
    "--skip=should_build_native_dev"
    "--skip=should_build_native_release"
    "--skip=should_build_web_dev"
    "--skip=should_build_web_release"
  ];

  postInstall = ''
    wrapProgram $out/bin/bevy --suffix PATH : ${
      lib.makeBinPath [
        cargo-generate
        binaryen
      ]
    }
  ''
  + (lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bevy \
      --bash <($out/bin/bevy completions bash) \
      --fish <($out/bin/bevy completions fish) \
      --zsh <($out/bin/bevy completions zsh)
  '');

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Bevy CLI tool and linter";
    mainProgram = "bevy";
    homepage = "https://thebevyflock.github.io/bevy_cli/";
    changelog = "https://github.com/TheBevyFlock/bevy_cli/releases/tag/cli-v${finalAttrs.version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
