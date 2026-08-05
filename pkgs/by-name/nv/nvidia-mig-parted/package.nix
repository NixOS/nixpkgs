{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nvidia-mig-parted";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "mig-parted";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iizYj7JEfBiGfSuuysAIWA2EujxoKclsHho8EHUmuFc=";
  };

  vendorHash = null;

  excludedPackages = [
    "cmd/nvidia-mig-manager"
    "deployments/devel"
  ];

  # Avoid undefined symbol: nvmlGpuInstanceGetComputeInstanceProfileInfoV
  ldflags = [ "-extldflags=-Wl,-z,lazy" ];

  meta = {
    description = "MIG Partition Editor for NVIDIA GPUs";
    homepage = "https://github.com/nvidia/mig-parted";
    changelog = "https://github.com/NVIDIA/mig-parted/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "nvidia-mig-parted";
  };
})
