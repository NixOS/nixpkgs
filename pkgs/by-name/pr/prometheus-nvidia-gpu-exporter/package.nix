{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nvidia_gpu_exporter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-RS5vMh4R/BcrhW/azx+J8TOdLA6oZObQBe6bvUPpboQ=";
  };

  vendorHash = "sha256-6d6mMq2bG0D7Cd4ApRGAN+PM56wP+S0jOu09eucLCf8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=unknown"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  meta = with lib; {
    description = "Nvidia GPU exporter for the Prometheus monitoring system";
    mainProgram = "nvidia_gpu_exporter";
    homepage = "https://github.com/utkuozdemir/nvidia_gpu_exporter";
    license = licenses.mit;
  };
}
