{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke2";
  version = "1.27.1+rke2r1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MPhE4dkFDLMG/Zxn9UqUMmbV95wfNDJU9C5CT8Ap5iA=";
  };

  vendorHash = "sha256-STpM7GxLdEhe7tfa6n6jyUSQsE9D91pCBvw1n7Q9qMc=";

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
