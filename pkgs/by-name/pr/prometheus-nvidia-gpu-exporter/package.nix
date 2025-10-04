{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${version}";
    hash = "sha256-d5/sWgfb4rGfHHeHOunHkm61F6o9L/z0MLh7iRABEYg=";
  };

  vendorHash = "sha256-kzjaMLPZrjgdeNSLapp3t+b8Y++Q8Cqj1hkU+GVGm88=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/prometheus/common/version.Version=${version}"
    "-X=github.com/prometheus/common/version.Revision=${src.rev}"
    "-X=github.com/prometheus/common/version.Branch=${src.rev}"
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
}
