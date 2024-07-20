{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-cMaOqybXzbAelhSfUal4kgQKwz/dEp/fVQ8SyjaaAZU=";
  };

  vendorHash = "sha256-M2nco2qxutpxKv//o+h2LY0x5Tk6DWxFL383cpGVnkI=";

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

  meta = with lib; {
    description = "Collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    mainProgram = "kubectl-gadget";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ kranurag7 devusb ];
  };
}
