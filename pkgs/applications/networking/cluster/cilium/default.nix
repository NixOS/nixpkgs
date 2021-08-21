{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "07p62zifycw7gnwkd3230jsjns80k2q9fbj8drzp84s9cp7ddpa9";
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
