{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TPgXjM7RyjI8NmfiZHkHF3txfzAwjOg7kGODBj37JEI=";
  };

  vendorHash = "sha256-0H9K3/BwdSExADFHaYtn2RrHZ6AyEjzlBKYXL/Ow9JA=";

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
