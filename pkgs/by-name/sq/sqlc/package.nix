{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sqlc";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kACZusfwEIO78OooNGMXCXQO5iPYddmsHCsbJ3wkRQs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-5KVCG92aWVx2J78whEwhEhqsRNlw4xSdIPbSqYM+1QI=";

  subPackages = [ "cmd/sqlc" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sqlc \
      --bash <($out/bin/sqlc completion bash) \
      --fish <($out/bin/sqlc completion fish) \
      --zsh <($out/bin/sqlc completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "sqlc";
  };
})
