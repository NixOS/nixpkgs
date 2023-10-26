{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubevpn";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner  = "KubeNetworks";
    repo   = "kubevpn";
    rev    = "v${version}";
    sha256 = "sha256-fXRzo68d65FISW+m/BTmwOXlJiCmMm9Az1qsGGsbPIA=";
  };

  vendorHash = "sha256-EcHHSOAr93M2kPhEaZSpvpZCq4pi1NCedo9hw1Mn0a4=";

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
