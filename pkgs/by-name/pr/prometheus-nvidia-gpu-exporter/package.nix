{
  lib,
  stdenv,
  autoAddDriverRunpath,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.16.0";

  env.CGO_ENABLED = if stdenv.hostPlatform.isLinux then "1" else "0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VnDOf7GX9p7RUHEzqLflcgAkuwrCvPqIgwB9YQ11Iy4=";
  };

  vendorHash = "sha256-TmYfYFMCiikvxYVRaGF8tsdQDAMCLpZ6WgI0dDKuTZw=";

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoAddDriverRunpath;

  # go-nvml loads the driver at runtime and guards optional symbols before use.
  hardeningDisable = lib.optional stdenv.hostPlatform.isLinux "bindnow";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X=github.com/prometheus/common/version.Revision=${finalAttrs.src.rev}"
    "-X=github.com/prometheus/common/version.Branch=${finalAttrs.src.rev}"
    "-X=github.com/prometheus/common/version.BuildUser=nixbld@nixpkgs"
    "-X=github.com/prometheus/common/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Nvidia GPU exporter for prometheus using nvidia-smi binary or NVML";
    homepage = "https://github.com/utkuozdemir/nvidia_gpu_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "nvidia_gpu_exporter";
  };
})
