{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "1hlj7i7pjyvrf9cpx6s41sdn7wjwfk7c0akx45kw662vrxcqcgf2";
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
