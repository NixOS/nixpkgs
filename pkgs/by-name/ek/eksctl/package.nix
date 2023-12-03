{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "eksctl";
  version = "0.164.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    hash = "sha256-ENlMcwk4bMbIzV353vt+EG776+/ajrg5la3JeA81QS4=";
  };

  vendorHash = "sha256-NOhssVWEkvoXpmnsCVVT7Li0ePGWDSGIlB2MyFtMnpI=";

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  tags = [ "netgo" "release" ];

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
    description = "A CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd Chili-Man ];
    mainProgram = "eksctl";
  };
}
