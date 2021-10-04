{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hlJfgNFHEjIrvHhaAje1XQbNO6e3D/qcCmdVFhklwqs=";
  };

  vendorSha256 = "sha256-3OTkigryWsyCytyNMyumJJtc/BwtdryvDQRan2dzqfg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/k0sproject/k0sctl/version.Version=${version}"
  ];

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
