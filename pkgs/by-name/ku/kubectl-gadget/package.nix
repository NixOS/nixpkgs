{ lib, buildGoModule, fetchFromGitHub, kubectl-gadget, testers }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-qOenoC1NycRVFMXETJ1WpAhjeUAnminhkhJ39skvt4k=";
  };

  vendorHash = "sha256-V2bgMFJGo1t1MiJyACdB9mjM2xtHwgH6bNEbEeZC2XM=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/inspektor-gadget/inspektor-gadget/internal/version.version=v${version}"
    "-X main.gadgetimage=ghcr.io/inspektor-gadget/inspektor-gadget:v${version}"
    "-extldflags=-static"
  ];

  tags = [
    "withoutebpf"
  ];

  subPackages = [ "cmd/kubectl-gadget" ];

  passthru.tests.version = testers.testVersion {
    package = kubectl-gadget;
    command = "kubectl-gadget version || true"; # mask non-zero return code if no kubeconfig present
    version = "v${version}";
  };

  meta = with lib; {
    description = "Collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    mainProgram = "kubectl-gadget";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ kranurag7 devusb ];
  };
}
