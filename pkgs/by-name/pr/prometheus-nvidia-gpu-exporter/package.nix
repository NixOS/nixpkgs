{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "prometheus-nvidia-gpu-exporter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "nvidia_gpu_exporter";
    rev = "v${version}";
    hash = "sha256-RS5vMh4R/BcrhW/azx+J8TOdLA6oZObQBe6bvUPpboQ=";
  };

  vendorHash = "sha256-6d6mMq2bG0D7Cd4ApRGAN+PM56wP+S0jOu09eucLCf8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/prometheus/common/version.Version=${version}"
    "-X=github.com/prometheus/common/version.Revision=${src.rev}"
    "-X=github.com/prometheus/common/version.Branch=${src.rev}"
    "-X=github.com/prometheus/common/version.BuildUser=goreleaser"
    "-X=github.com/prometheus/common/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "Nvidia GPU exporter for prometheus using nvidia-smi binary";
    homepage = "https://github.com/utkuozdemir/nvidia_gpu_exporter.git";
    license = licenses.mit;
    maintainers = with maintainers; [ ck3d ];
    mainProgram = "nvidia-gpu-exporter";
  };
}
