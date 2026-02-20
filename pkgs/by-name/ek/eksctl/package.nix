{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "eksctl";
  version = "0.223.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "eksctl";
    rev = finalAttrs.version;
    hash = "sha256-AGtKkfEeLwL0mSdObL8fS2wOHgFr/lKahImvj5Ox7qo=";
  };

  vendorHash = "sha256-qU2Cb9ob9/jMFMS8eanxjxpQSjfV71t8gLa4HfSu0Ok=";

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  tags = [
    "netgo"
    "release"
  ];

  ldflags = [
    "-s"
    "-w"
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

  meta = {
    description = "CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
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
