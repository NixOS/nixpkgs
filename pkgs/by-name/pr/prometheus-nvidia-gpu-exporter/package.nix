{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.15.1";

  env.CGO_ENABLED = 0;

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-75azonvsJ9fZSp9ht8ZUj4XmkmfsSRl2pp0jfBSEFiI=";
  };

  vendorHash = "sha256-9CPuhBDi8PnYyFYmW5XbutpRrA7ukPDiXCH4+94b9/o=";

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
