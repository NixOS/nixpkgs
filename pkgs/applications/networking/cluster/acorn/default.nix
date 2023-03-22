{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "acorn";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "acorn-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X4EXF6t6RzjHCbo2+oB69sFoqeRc5blSmB7x1iQCYIA=";
  };

  vendorHash = "sha256-cx+7vbVpoeNwE4mNaQKuguALObyCrEA7EQPdnJ0H9mM=";

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
