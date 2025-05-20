{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kubectl-gadget,
  testers,
}:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-fizq0S2pvhrMwGR/l6yqzq3IXDuD01Abi3VRiNJqs48=";
  };

  vendorHash = "sha256-zBEb61gxjCRXjdANIHWKVNu5Do+iEmxttKvyiYp8FYQ=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
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
    command = "kubectl-gadget version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    mainProgram = "kubectl-gadget";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kranurag7
      devusb
    ];
  };
}
