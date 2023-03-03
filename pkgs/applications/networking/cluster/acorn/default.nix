{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "acorn";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "acorn-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9+jI3GBRuX06+aN8C8C3K72kKtQVwmfAwhYLViuERxk=";
  };

  vendorHash = "sha256-t/q94B+ihcHh/XFHs1Z9yQTwoFKv/nkhIDykymGNA2w=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/acorn-io/acorn/pkg/version.Tag=v${version}"
    "-X github.com/acorn-io/acorn/pkg/config.AcornDNSEndpointDefault=https://alpha-dns.acrn.io/v1"
  ];

  # integration tests require network and kubernetes master
  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.acorn.io";
    changelog = "https://github.com/acorn-io/${pname}/releases/tag/v${version}";
    description = "A simple application deployment framework for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
