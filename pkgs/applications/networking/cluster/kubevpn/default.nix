{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubevpn";
  version = "1.1.35";

  src = fetchFromGitHub {
    owner  = "KubeNetworks";
    repo   = "kubevpn";
    rev    = "v${version}";
    sha256 = "sha256-fY0SKluJ1SG323rV7eDdhmDSMn49aITXYyFhR2ArFTw=";
  };

  vendorHash = "sha256-aU8/C/p/VQ3JYApgr/i5dE/nBs0QjsvXBSMnEmj/Sno=";

  # TODO investigate why some config tests are failing
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/KubeNetworks/kubevpn/releases/tag/${src.rev}";
    description = "Create a VPN and connect to Kubernetes cluster network, access resources, and more";
    homepage = "https://github.com/KubeNetworks/kubevpn";
    license = licenses.mit;
    maintainers = with maintainers; [ mig4ng ];
  };
}
