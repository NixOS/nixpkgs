{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "eksctl";
  version = "0.210.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "eksctl";
    rev = version;
    hash = "sha256-d5P9bfneUpyAB9cxnu7Hw4ZOykWf8/GSVclNtIjTe6g=";
  };

  vendorHash = "sha256-vhYexIdkn8Y5U5YZewj/O8sJCt/VimZU4E4kn0/1lU4=";

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  tags = [
    "netgo"
    "release"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/weaveworks/eksctl/pkg/version.gitCommit=${src.rev}"
    "-X github.com/weaveworks/eksctl/pkg/version.buildDate=19700101-00:00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd eksctl \
      --bash <($out/bin/eksctl completion bash) \
      --fish <($out/bin/eksctl completion fish) \
      --zsh  <($out/bin/eksctl completion zsh)
  '';

  meta = {
    description = "CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    changelog = "https://github.com/eksctl-io/eksctl/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      xrelkd
      Chili-Man
      ryan4yin
    ];
    mainProgram = "eksctl";
  };
}
