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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "reteps";
    repo = "dockerfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WfwrFe3E+CzfZ0ITSjMD8h4yrG+mnC6y0L+7OSYjMsw=";
  };

  vendorHash = "sha256-r8vmbZ4oyplqIU6R/6hhcyjoR3E/mOFrB69TrfPYxRI=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/reteps/dockerfmt/cmd.Version=${finalAttrs.version}"
  ];

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
