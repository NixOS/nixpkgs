{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-FhkeovWuDQZ7KwyIk6YY/iWfRQxTUT0fcAJcCiTZ9Cg=";
  };

  vendorHash = "sha256-mtWh5nJrdy7PIk4+S+66Xgqpllg6lAyc73lW/bjV5AE=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${version}/RELEASE-NOTES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
