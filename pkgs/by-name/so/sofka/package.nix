{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  bashInteractive,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sofka";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "nklmilojevic";
    repo = "sofka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oUubm3fIE16UHNhTVfvFW1mBSa8fkh93BAdsdLMYFOE=";
  };

  cargoHash = "sha256-MVNpawnJp/rlXQ89tptDatAhj8B8FHCVKoILTEnvwus=";

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  # The test suite builds rustls-backed HTTP clients, which need native root
  # CA certificates, and exercises the generated bash completion script, which
  # needs a bash with programmable completion.
  nativeCheckInputs = [
    bashInteractive
    cacert
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes TUI, reimagined in Rust";
    homepage = "https://github.com/nklmilojevic/sofka";
    changelog = "https://github.com/nklmilojevic/sofka/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "sofka";
    maintainers = with lib.maintainers; [ jakuzure ];
    platforms = lib.platforms.unix;
  };
})
