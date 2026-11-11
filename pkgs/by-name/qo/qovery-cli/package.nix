{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGo127Module (finalAttrs: {
  pname = "qovery-cli";
  version = "1.177.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WzqbFjFmajDCJco3gKYhFmXgfGzs7PGfAswS4rHPfZE=";
  };

  vendorHash = "sha256-Er8INNpCxMu5a/CPKb1yvvKy7PZitsO8HIlmzmOjH30=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-X=github.com/qovery/qovery-cli/utils.Version=v${finalAttrs.version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd qovery-cli \
      --bash <($out/bin/qovery-cli completion bash) \
      --fish <($out/bin/qovery-cli completion fish) \
      --zsh <($out/bin/qovery-cli completion zsh)
  '';

  # need network
  doCheck = false;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];

  versionCheckProgramArg = "version";

  meta = {
    description = "Qovery Command Line Interface";
    homepage = "https://github.com/Qovery/qovery-cli";
    changelog = "https://github.com/Qovery/qovery-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "qovery-cli";
  };
})
