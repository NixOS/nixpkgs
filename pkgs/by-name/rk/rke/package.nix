{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rke";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "rke";
    rev = "v${version}";
    hash = "sha256-xa9f82jbSjJEd0XR1iaqu3qA3O5G5vfj4RRhpT9c32Y=";
  };

  vendorHash = "sha256-OWC8OZhORHwntAR2YHd4KfQgB2Wtma6ayBWfY94uOA4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=v${version}"
  ];

  meta = {
    homepage = "https://github.com/rancher/rke";
    description = "Extremely simple, lightning fast Kubernetes distribution that runs entirely within containers";
    mainProgram = "rke";
    changelog = "https://github.com/rancher/rke/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
