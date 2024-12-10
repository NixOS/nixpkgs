{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-+eysHATyAdCN6HVPN2bgc/ICo+XXaef0H0UDW2xCcjc=";
  };

  vendorHash = "sha256-0XByai7fEnkmEEkH1koVM1+z3UNFLbsUCK3sP4KBe+A=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
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
    maintainers = with maintainers; [
      kranurag7
      devusb
    ];
  };
}
