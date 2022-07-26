{ lib, buildGoModule, fetchFromGitHub, testers, kube-router }:

buildGoModule rec {
  pname = "kube-router";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WBnJPCZHtJWckoFvE8e+eAa2EC/RA7yOMlW+Cemw53Q=";
  };

  vendorSha256 = "sha256-5co+288KZf/dx/jZ7xIGh6kxuW3DdbpAsrZgYob3nWk=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudnativelabs/kube-router/pkg/version.Version=${version}"
    "-X github.com/cloudnativelabs/kube-router/pkg/version.BuildDate=Nix"
  ];

  passthru.tests.version = testers.testVersion {
    package = kube-router;
  };

  meta = with lib; {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens johanot ];
    platforms = platforms.linux;
  };
}
