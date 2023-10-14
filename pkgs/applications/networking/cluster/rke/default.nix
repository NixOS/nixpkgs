{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rr6CN5ik4vuLNqzNPvISfRfOjTcD48pSre2K6xr6xSk=";
  };

  vendorHash = "sha256-3bivFrn2xDyILD1ugSr7IehhNq4vkqShFQI3sbeY0iY=";

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
