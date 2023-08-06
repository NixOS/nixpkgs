{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256-QB1OX5G0WkV8k84282+haQc2JVMUhsO99cpEMrHR9qY=";
  };

  vendorHash = "sha256-5ydul1buJignI5KCn6TMYCjdJ6ni6NgYQrnrGBPADI4=";

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
