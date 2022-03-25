{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cmctl";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cert-manager";
    rev = "v${version}";
    sha256 = "sha256-Hx6MG5GCZyOX0tfpg1bfUT0BOI3p7Mws1VCz2PuUuw8=";
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

