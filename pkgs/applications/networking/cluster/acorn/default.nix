{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "acorn";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "acorn-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IzjCYVQ9RhuAmgloue421F43ARviaHW7mTkLhLW/VPM=";
  };

  vendorHash = "sha256-z2ya/CgH9AcxHe73Yt9XWbJqH4OrZWt0bRDsna5hYeo=";

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
