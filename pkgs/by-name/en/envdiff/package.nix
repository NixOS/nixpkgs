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
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GBerghoff";
    repo = "envdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tV+EPSW2pojRZdGoQxBVZ5n2I+BnStj4DLdN7k9Py+A=";
  };

  vendorHash = "sha256-602hi6RR8hpxb9htAE8jZUHClRpss6armnKfz4Rg3fs=";

  ldflags = [
    "-s"
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
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cli tool to snapshot and diff environments - helping find the differences that matter";
    homepage = "https://github.com/GBerghoff/envdiff";
    changelog = "https://github.com/GBerghoff/envdiff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "envdiff";
  };
})
