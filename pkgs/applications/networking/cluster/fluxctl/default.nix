{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "sha256-PcDipeW+ebGm6w/htjyx1/PXaanh2gp3EyHkcLY9peo=";
  };

  vendorSha256 = "sha256-CxGa95x742vS+8WxK/I2ZbEn2mJPwpXa5zm3xBNbX4U=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [ "cmd/fluxctl" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/fluxctl completion $shell > fluxctl.$shell
      installShellCompletion fluxctl.$shell
    done
  '';

  meta = with lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = "https://github.com/fluxcd/flux";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih Br1ght0ne ];
  };
}
