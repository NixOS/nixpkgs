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
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "Macmod";
    repo = "godap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Xlf9VL1rJ7PMk8dRia0bmYkx1gCstnp/Sv9FO1BxSw=";
  };

  vendorHash = "sha256-wqBpsZdfU9xOGKbspWYq8A6xmCrIQrKFhx4s7M6K6/M=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" ];

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
    maintainers = with lib.maintainers; [
      kpbaks
      mrdev023
    ];
    mainProgram = "godap";
  };
})
