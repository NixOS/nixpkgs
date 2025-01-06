{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rke";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BatjRfUosYD5e3TNzgREuMeGSA2lknZMG3/y+0V2NkU=";
  };

  vendorHash = "sha256-Lp14xvhn4xzOurTa8sRk0A1X1c/sj1clw7niVTRgNeM=";

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
