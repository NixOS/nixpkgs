{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "godap";
  version = "2.10.7";

  src = fetchFromGitHub {
    owner = "Macmod";
    repo = "godap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ThN280XriiNXADPvZMwJMAFbAd7rqW8hNs1Fcs1yIAM=";
  };

  vendorHash = "sha256-D5Eq2JFIEmxO/FBGON+nKtGktWPOzXfv8l5akRTpz7Q=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal user interface (TUI) for LDAP";
    homepage = "https://github.com/Macmod/godap";
    changelog = "https://github.com/Macmod/godap/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "godap";
  };
})
