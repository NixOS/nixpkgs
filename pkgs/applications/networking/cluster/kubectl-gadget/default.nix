{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-e93rQRIF3CmXjQhpACxBp4WnPtQ5IJnm7H5BcHGqH0c=";
  };

  vendorHash = "sha256-YkOw4HpbX6e6uIAUa7zQPah/ifRfB4ICi90AxleKNNE=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
    "-extldflags=-static"
  ];

  tags = [
    "withoutebpf"
  ];

  subPackages = [ "cmd/kubectl-gadget" ];

  meta = with lib; {
    description = "A collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ kranurag7 ];
  };
}
