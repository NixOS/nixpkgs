{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256:16i9biyvzkpgxyfb41afaarnlm59vy02nspln5zq69prg6mp8rwa";
  };

  vendorHash = "sha256-Kj8gP5393++nPeX38TX6duB9OO/ql7hpRA5gTTtTl+M=";

  CGO_ENABLED = 0;

  ldflags = [
    "-X main.version=v${version}"
  ];

  subPackages = [ "cmd/kubectl-gadget" ];

  meta = with lib; {
    description = "A collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ kranurag7 ];
  };
}
