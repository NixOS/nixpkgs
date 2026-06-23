{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-gadget";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WcIPubDzj3LPf1KUWfmxdlBGnG2x68hax/ZQKwSNifc=";
  };

  vendorHash = "sha256-aEzzXcsM3D+Sp6LBms5+RzWirdC5iFvN2IiwbOXCrEw=";

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
