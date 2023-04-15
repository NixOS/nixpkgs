{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
    hash = "sha256:1gn09kpkw8q2lxc8nic7hd1lhp0z4vscs8yvvxjzp1i9mw8s35xh";
  };

  vendorHash = "sha256-Y76Y3KR80dCx8+f6M0h5J6glGQGhXYE2KQM4jdJcDEM=";

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
