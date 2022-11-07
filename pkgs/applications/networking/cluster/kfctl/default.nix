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

  proxyVendor = true; # fix vendor with go > 1.17, should be able to remove when package is bumped
  vendorSha256 = "sha256-gFA9jxAM0IoWHl16/NrHd7PYdTcZt4y66PtiVe4JveU=";

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
  };
}
