{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.19.5";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-giCFea4uZNztWxQhsYSdh2KtFE0uU0hf/lhGnY9OsIE=";
  };

  vendorHash = "sha256-i8MpQsqD1SBf+qPwYTFDTYDE4mvLdpKUoKML+u1027U=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
