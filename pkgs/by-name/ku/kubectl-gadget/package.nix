{ lib, buildGoModule, fetchFromGitHub, kubectl-gadget, testers }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-M0RfwO8YcjMx2eBbSjo4BgTJHbzFnpqhGhhLg9l1KYY=";
  };

  vendorHash = "sha256-gYaO+8WhMZNTSBndncrB9JDe3CYL50JGP45ugg6DMDQ=";

  env.CGO_ENABLED = 0;

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
    command = "kubectl-gadget version";
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
