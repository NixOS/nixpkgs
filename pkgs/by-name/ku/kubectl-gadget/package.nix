{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-gadget";
  version = "0.58.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F2KR3MvxbLfs800rh/+yjo/54XwJZLjvNMDuMRAsqbk=";
  };

  vendorHash = "sha256-9Hoi8GSeoLvSmoH5uRU1KpWlrL0OpDBK/rj6M8b5v8Y=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/inspektor-gadget/inspektor-gadget/internal/version.version=v${finalAttrs.version}"
    "-X main.gadgetimage=ghcr.io/inspektor-gadget/inspektor-gadget:v${finalAttrs.version}"
    "-extldflags=-static"
  ];

  tags = [
    "withoutebpf"
  ];

  subPackages = [ "cmd/kubectl-gadget" ];

  meta = {
    description = "Collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    mainProgram = "kubectl-gadget";
    homepage = "https://inspektor-gadget.io";
    changelog = "https://github.com/inspektor-gadget/inspektor-gadget/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kranurag7
      devusb
    ];
  };
})
