{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-gadget";
<<<<<<< HEAD
  version = "0.47.0";
=======
  version = "0.46.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZGi7zsIphiXNLfVc6u+ZSGsgWWcMaBpyt1BpwS2WRCU=";
  };

  vendorHash = "sha256-0vpPBQ1ty4FZMj3bgB56Gu5pNdo7SyhxvGQOHos6m9s=";
=======
    hash = "sha256-y5eqkTt9CnEPOyFERWhBPqrgnMGaVuWN2FoDV0pDjdI=";
  };

  vendorHash = "sha256-TBaMbIwR/7MzPn8rYgjqeMLma3arwr5W9HiTztd8z9E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    mainProgram = "kubectl-gadget";
    homepage = "https://inspektor-gadget.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    mainProgram = "kubectl-gadget";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kranurag7
      devusb
    ];
  };
}
