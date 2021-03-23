{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-wzaNFM/4V2mWqhkqeT70ieQuhgNK79U2b7PhxKqn/X0=";
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
