{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ldN0Fqh0V6JziTy5ml/i/un4/1o8MSeIAvrH5EyOeiw=";
  };

  vendorHash = "sha256-wuEsG2VKU4F/phSqpzUN3wChD93V4AE7poVLJu6kpF0=";

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
