{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "eksctl";
  version = "0.207.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    hash = "sha256-USWeMzJ1k+sJx2p3FzFhbO48m61WUuCvp7Juwa9jtus=";
  };

  vendorHash = "sha256-TEw5ts51M/nvcljqrCHIkTGk64dhhEamhkP/qS/y1uo=";

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

  meta = with lib; {
    description = "CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    changelog = "https://github.com/eksctl-io/eksctl/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      xrelkd
      Chili-Man
    ];
    mainProgram = "eksctl";
  };
}
