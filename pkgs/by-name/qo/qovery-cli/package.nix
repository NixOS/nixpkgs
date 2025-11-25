{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "qovery-cli";
  version = "1.56.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IeK0GcYi3J86IABYfKvE3ict8AOnpuwuecqadNYcVrY=";
  };

  vendorHash = "sha256-owsLDP2ufW0kXmWOFtAiXKx/YiKEGL0QXkRQy1uA2Uw=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-X github.com/qovery/qovery-cli/utils.Version=v${finalAttrs.version}" ];

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
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "qovery-cli";
  };
})
