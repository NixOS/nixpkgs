{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "09ds5qn13l6l8kl2i01hgy6pqr30z1rm447ax32lf79zp8hca3r3";
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
