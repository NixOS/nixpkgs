{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1/WXpXZ6f4p4IZ/yropCjH3hHt+t5HGw0aq0HFk04mo=";
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
