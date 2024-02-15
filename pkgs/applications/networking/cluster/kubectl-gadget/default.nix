{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-JC6+6PADTfxpVRowh09fXC8EO/qIsUTTba2uYxxxJ/A=";
  };

  vendorHash = "sha256-7pwEQ1O3i4SmVSTTmOX9KPR0ePdDpf2dQgD4e6fDyzQ=";

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
