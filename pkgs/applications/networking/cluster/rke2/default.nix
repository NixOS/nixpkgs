{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke2";
  version = "1.27.2+rke2r1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jzm2tYwsomLifAfmb0w1+/FpCgtOk+O8DRmy1OgzfmE=";
  };

  vendorHash = "sha256-VVc1IgeR+LWEexTyIXtCcF6TtdDzsgP4U4kqArIKdU4=";

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
