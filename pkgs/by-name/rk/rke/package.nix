{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rke";
  version = "1.8.12";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "rke";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OXNnf/JCzW2PMVqLuz+1PAsBaoBhWUVJ1H0P0Sl/Eko=";
  };

  vendorHash = "sha256-OWC8OZhORHwntAR2YHd4KfQgB2Wtma6ayBWfY94uOA4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=v${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/rancher/rke";
    description = "Extremely simple, lightning fast Kubernetes distribution that runs entirely within containers";
    mainProgram = "rke";
    changelog = "https://github.com/rancher/rke/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
