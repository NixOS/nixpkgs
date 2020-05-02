{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "1h8n2219xh0gl42kz3rkv3aj3wfwivvs9skwbbrvmrkwwrpxkgdj";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kubeseal" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}