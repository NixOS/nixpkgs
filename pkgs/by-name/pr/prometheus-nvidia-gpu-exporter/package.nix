{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${version}";
    hash = "sha256-yaMyvI70BEn23heAkvJ8wU08CJp+wMzRnwt4py6sZhs=";
  };

  vendorHash = "sha256-A9CY14pdZLgm5eCWYlWmn3H7VPM4yxramv6pi2ER64I=";

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
