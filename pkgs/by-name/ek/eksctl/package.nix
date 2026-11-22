{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "eksctl";
  version = "0.232.0";

  src = fetchFromGitHub {
    owner = "eksctl-io";
    repo = "eksctl";
    rev = finalAttrs.version;
    hash = "sha256-6cAAP61MO9qNJElzUUU8lRtp7cq/ztQzmvC2XOpzOGk=";
  };

  vendorHash = "sha256-AMqsuxGx35sX0DthNkcISRVJued0MdxltVhltr1EUVY=";

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  tags = [
    "netgo"
    "release"
  ];

  ldflags = [
    "-s"
    "-X github.com/weaveworks/eksctl/pkg/version.gitCommit=${finalAttrs.src.rev}"
    "-X github.com/weaveworks/eksctl/pkg/version.buildDate=19700101-00:00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd eksctl \
      --bash <($out/bin/eksctl completion bash) \
      --fish <($out/bin/eksctl completion fish) \
      --zsh  <($out/bin/eksctl completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "CLI for Amazon EKS";
    homepage = "https://github.com/eksctl-io/eksctl";
    changelog = "https://github.com/eksctl-io/eksctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      xrelkd
      Chili-Man
      ryan4yin
    ];
    mainProgram = "eksctl";
  };
})
