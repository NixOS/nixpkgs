{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nvidia-mig-parted";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.13.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "mig-parted";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-No8NzmjDjri77r7YzuSYsGMvHHMxsvxJaddarKcDMr0=";
=======
    hash = "sha256-oSoPgap/LFjJ1tW3KLlcQ/zdym9A9h5zownktVxdQfY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
