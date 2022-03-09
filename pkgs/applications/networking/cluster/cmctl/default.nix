{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cmctl";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cert-manager";
    rev = "v${version}";
    sha256 = "sha256-RO7YcGEfAQ9kTxfqgekYf6M5b6Fg64hCPLA/vt6IWp8=";
  };

  vendorSha256 = "sha256-4zhdpedOmLl/i1G0QCto4ACxguWRZLzOm5HfMBMtvPY=";

  subPackages = [ "cmd/ctl" ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/ctl $out/bin/cmctl
    installShellCompletion --cmd cmctl \
      --bash <($out/bin/cmctl completion bash) \
      --fish <($out/bin/cmctl completion fish) \
      --zsh <($out/bin/cmctl completion zsh)
  '';

  meta = with lib; {
    description = "A CLI tool for managing Cert-Manager service on Kubernetes clusters";
    downloadPage = "https://github.com/cert-manager/cert-manager";
    license = licenses.asl20;
    homepage = "https://cert-manager.io/";
    maintainers = with maintainers; [ superherointj ];
  };
}

