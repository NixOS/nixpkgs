{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dE5ERAOocAJnYjWmF057ifPBhDGK41p7cGl+rX2IzRg=";
  };

  vendorHash = "sha256-6eX+SVm6+/NWuNRD2MkJaDNi9YwJnojx9Df+o1km88I=";

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
