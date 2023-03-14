{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kfctl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "kubeflow";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FY7o4QULobLY1djfcc2l6awE/v2stN7cc2lffMkjoPc=";
  };

  vendorSha256 = null; #vendorSha256 = "";

  subPackages = [ "cmd/kfctl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
  installShellCompletion --cmd eksctl \
    --bash <($out/bin/kfctl completion bash) \
    --zsh <($out/bin/kfctl completion zsh)
  '';

  meta = with lib; {
    description = "A CLI for deploying and managing Kubeflow";
    homepage = "https://github.com/kubeflow/kfctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ mvnetbiz ];
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
  };
}
