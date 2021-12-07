{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hubble";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/6fcnY/wqrbi0IbBkRgho5DM5VVmplmHeRelfnEOGHg=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    license = licenses.asl20;
    homepage = "https://github.com/cilium/hubble/";
    maintainers = with maintainers; [ humancalico ];
  };
}
