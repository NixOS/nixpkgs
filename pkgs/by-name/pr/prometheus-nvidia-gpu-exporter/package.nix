{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KMXdKUBHL6Fq4GQC5paDqn9vb4/KBMcfq4c1njhGi6o=";
  };

  vendorHash = "sha256-QG2Pcg+RwnGMBcDMjaFEROTDTr39J0oGJplO7vPvXYk=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X=github.com/prometheus/common/version.Revision=${finalAttrs.src.rev}"
    "-X=github.com/prometheus/common/version.Branch=${finalAttrs.src.rev}"
    "-X=github.com/prometheus/common/version.BuildUser=goreleaser"
    "-X=github.com/prometheus/common/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Nvidia GPU exporter for prometheus using nvidia-smi binary";
    homepage = "https://github.com/utkuozdemir/nvidia_gpu_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "nvidia_gpu_exporter";
  };
})
