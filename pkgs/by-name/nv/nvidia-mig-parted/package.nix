{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nvidia-mig-parted";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "mig-parted";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b+/Rz1Lj+Ef7fIw4g2el8td982SGKXb0iPboP53XGKQ=";
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
