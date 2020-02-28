{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "1d3m13pl30w8d7pxjdhspxprk2jm8cm25rc5s867z4a37c5igv7y";
  };

  modSha256 = "04dmjyz3vi2l0dfpyy42lkp2fv1vlfkvblrxh1dvb37phrkd5lbd";

  subPackages = [ "cmd/kubeseal" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
