{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dockerfmt";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "reteps";
    repo = "dockerfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cNxPe0LOZyUxyw43fmTQeoxvXcT9K+not/3SvChBSx4=";
  };

  vendorHash = "sha256-fLGgvAxSAiVSrsnF7r7EpPKCOOD9jzUsXxVQNWjYq80=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dockerfmt \
      --bash <($out/bin/dockerfmt completion bash) \
      --fish <($out/bin/dockerfmt completion fish) \
      --zsh <($out/bin/dockerfmt completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Dockerfile formatter: a modern dockfmt";
    homepage = "https://github.com/reteps/dockerfmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "dockerfmt";
  };
})
