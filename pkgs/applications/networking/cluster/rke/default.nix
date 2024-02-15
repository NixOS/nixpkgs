{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-p1hkiXHwh8Vo2LIP1BeE5XSc/gKjn9XN30usGwCVj7w=";
  };

  vendorHash = "sha256-eH4FBfX9LNb1UgSRsYSd1Fn2Ju+cL6t64u+/sf9uzNM=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X=main.VERSION=v${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rancher/rke";
    description = "An extremely simple, lightning fast Kubernetes distribution that runs entirely within containers";
    changelog = "https://github.com/rancher/rke/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
