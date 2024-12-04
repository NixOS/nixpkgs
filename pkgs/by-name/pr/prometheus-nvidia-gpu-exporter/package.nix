{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${version}";
    hash = "sha256-+YmZ25OhOeIulkOH/Apqh3jGQ4Vanv0GIuc/EjBiZ+w=";
  };

  vendorHash = "sha256-Dsp98EWRiRaawYmdr3KR2YTteeD9cmHUHQoq5CnH9gA=";

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
