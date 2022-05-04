{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cmctl";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "cert-manager";
    repo = "cert-manager";
    rev = "v${version}";
    sha256 = "sha256-h7GyzjVrfyMHY7yuNmmsym6KGKCQr5R71gjPBTUeMCg=";
  };

  vendorSha256 = "sha256-UYw9WdQ6VwzuuiOsa1yovkLZG7NmLYSW51p8UhmQMeI=";

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

