{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "14ahb02p1gqcqbjz6mn3axw436b6bi4ygq5ckm85jzs28s4wrfsv";
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
