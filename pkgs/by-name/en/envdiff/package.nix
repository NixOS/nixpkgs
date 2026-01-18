{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "envdiff";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "GBerghoff";
    repo = "envdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uA0LpXJewmie5gCDXCgM68m1kTWHL31RFqxLPcajPFU=";
  };

  vendorHash = "sha256-602hi6RR8hpxb9htAE8jZUHClRpss6armnKfz4Rg3fs=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cli tool to snapshot and diff environments - helping find the differences that matter";
    homepage = "https://github.com/GBerghoff/envdiff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "envdiff";
  };
})
