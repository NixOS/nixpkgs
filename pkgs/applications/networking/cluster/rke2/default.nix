{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke2";
  version = "1.26.3+rke2r1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MC3INsuXV2JmazdXOAAslFlApvql6uOnOkWV8u0diOw=";
  };

  vendorHash = "sha256-W9Phc1JYa3APAKvI34RWqMy4xfmwgX3BaOh4bQYFEnU=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/k3s-io/k3s/pkg/version.Version=v${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rancher/rke2";
    description = "RKE2, also known as RKE Government, is Rancher's next-generation Kubernetes distribution.";
    changelog = "https://github.com/rancher/rke2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zygot ];
  };
}
