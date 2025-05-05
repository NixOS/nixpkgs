{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rke";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/n6XGpwlGaaDDA5fJgCfDGr5GdaF3Qf5BS7fBdJmVYw=";
  };

  vendorHash = "sha256-OWC8OZhORHwntAR2YHd4KfQgB2Wtma6ayBWfY94uOA4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/rancher/rke";
    description = "Extremely simple, lightning fast Kubernetes distribution that runs entirely within containers";
    mainProgram = "rke";
    changelog = "https://github.com/rancher/rke/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
