{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-CQlyAgnEWeAfOn6xXeDFEGuSnaGZpGewg1tYYDCw8qE=";
  };

  vendorSha256 = "sha256-505nUMuFteOfIurGYRGHqo9diTSEa56tmQZ3jIGtULQ=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
