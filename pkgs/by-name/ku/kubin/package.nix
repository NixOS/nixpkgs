{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubin";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "3nd3r1";
    repo = "kubin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CeWnbX+GConUo6RppOGphDbUY+QAj+J36EySN5joEB8=";
  };

  modRoot = "cli";

  vendorHash = "sha256-ktWhId8XjhkrBc3YFldZBTSeUzjhbPjgGG2NARsyzRc=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/3nd3r1/kubin/cli/cmd.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/kubin
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubin \
      --bash <($out/bin/kubin completion bash) \
      --fish <($out/bin/kubin completion fish) \
      --zsh <($out/bin/kubin completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Capture a broken Kubernetes cluster with one command and share it as a link";
    homepage = "https://github.com/3nd3r1/kubin";
    changelog = "https://github.com/3nd3r1/kubin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _3nd3r1 ];
    mainProgram = "kubin";
  };
})
