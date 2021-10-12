{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hubble";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n1930hlaflx7kzqbz7vvnxw9hrps84kqibaf2ixnjp998kqkl6d";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    license = licenses.asl20;
    homepage = "https://github.com/cilium/hubble/";
    maintainers = with maintainers; [ humancalico ];
  };
}
