{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "eksctl";
  version = "0.191.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    hash = "sha256-ypHBvaCvQ1FZiQmKTkQ5h024pLBOpISZooSkIDa1OeQ=";
  };

  vendorHash = "sha256-mdGkdiYjcmsmYnM6fbyUeTC4Zb/Q1+geZrqJELv5i+4=";

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
    description = "CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    changelog = "https://github.com/eksctl-io/eksctl/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd Chili-Man ];
    mainProgram = "eksctl";
  };
}
