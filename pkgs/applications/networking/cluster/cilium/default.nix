{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "05qc1fcf4ahl1zvxv92mq3awiy5b1rq6r9l896b4hkp0m5lx9m3c";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    license = licenses.asl20;
    homepage = "https://www.cilium.io/";
    maintainers = with maintainers; [ humancalico ];
    mainProgram = "cilium";
  };
}
