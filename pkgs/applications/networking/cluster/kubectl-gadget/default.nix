{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-G2FvKnO+YuLlRlzfB1YMRhCHWa6v4sMFLyDqp12bzn4=";
  };

  vendorHash = "sha256-IrSx1iCOd95CWyLo6WuEtTFm6p62se/t8dcBmH5eOP4=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/inspektor-gadget/inspektor-gadget/cmd/common.version=v${version}"
    "-X main.gadgetimage=ghcr.io/inspektor-gadget/inspektor-gadget:v${version}"
    "-extldflags=-static"
  ];

  tags = [
    "withoutebpf"
  ];

  subPackages = [ "cmd/kubectl-gadget" ];

  meta = with lib; {
    description = "A collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    mainProgram = "kubectl-gadget";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ kranurag7 devusb ];
  };
}
