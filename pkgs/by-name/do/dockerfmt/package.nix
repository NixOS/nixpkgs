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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "reteps";
    repo = "dockerfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6a/sbnxZYGCaqz7H+YYLaaOg70y6lV21exeyuOeSDKw=";
  };

  vendorHash = "sha256-Fx4i+9mFy3tkFNVS5v8wP0KGsVgHOCIjk6QePJhH+c4=";

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
