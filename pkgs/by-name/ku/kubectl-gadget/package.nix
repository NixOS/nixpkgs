{ lib, buildGoModule, fetchFromGitHub, kubectl-gadget, testers }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-c6hy7B8zaU/LnTMAohc9KPzu1ocOVFJ9wL4GOIwxqkw=";
  };

  vendorHash = "sha256-7HfYCHxQUapDo33IAzxCp2iaL4G7oOqK0KyjqbmbR/w=";

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
