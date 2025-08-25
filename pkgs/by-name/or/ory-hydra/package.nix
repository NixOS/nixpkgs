{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule rec {
  pname = "ory-hydra";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    tag = "v${version}";
    hash = "sha256-f/pBRrFMfpcYSfejIGpCD5Kywtg5oyovw5RemvRDPTs=";
  };

  vendorHash = "sha256-g2NDPwLgM/LmndCgh5pXjc1DJ3pnGcHlWm+opPVK1bE=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ory/hydra/v2/driver/config.Version=${version}"
    "-X github.com/ory/hydra/v2/driver/config.Commit=${src.tag}"
  ];

  meta = {
    description = "Open-source identity and access proxy that authorizes HTTP requests based on sets of rules";
    homepage = "https://www.ory.sh/hydra/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ camcalaquian ];
    mainProgram = "hydra";
  };
}
