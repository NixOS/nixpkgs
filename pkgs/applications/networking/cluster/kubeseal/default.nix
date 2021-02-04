{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-sUeXzmgSOkpqzqrX9+wNGj2X7gcf5QSpavXK4MJe8qE=";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "cmd/kubeseal" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
