{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecm";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-njib9gfCay3DYRUBvc6Hi6khtzqU/Qit1/jBfISY3gI=";
  };

  vendorHash = "sha256-MIb4vJh2r5T3oJAtpoTd/yT3r+BXfxv0qxfRPcNMDko=";
  ldflags = [ "-s" "-w" "-X github.com/sunny0826/kubecm/version.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
