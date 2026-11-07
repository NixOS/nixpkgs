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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "reteps";
    repo = "dockerfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1MkDS4KQzh3BBWShsqMl1I55bZvZewtgMcFbhTMhPhw=";
  };

  vendorHash = "sha256-RSVujjyQUSqAg2pXuVNMglxOJ4qk+HF/J+gQEYNDqkg=";

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
