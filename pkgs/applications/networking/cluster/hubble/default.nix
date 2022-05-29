{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hubble";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L8sRvIA89RiXjrG0WcH72iYKlNTFvmQrveA9k5EBRKo=";
  };

  vendorSha256 = null;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    license = licenses.asl20;
    homepage = "https://github.com/cilium/hubble/";
    maintainers = with maintainers; [ humancalico ];
  };
}
