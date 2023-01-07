{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.18.3";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-vlNFIxhytgRtECj42Xng+j69JPciID26g1q8w9K14xY=";
  };

  vendorHash = "sha256-JpAQ8tyGJXOUH13uHHCtaYd/jbqZ8zZNCNq7ddPf6U8=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  # Depends on docker
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = kluctl;
    version = "v${version}";
  };

  meta = with lib; {
    description = "The missing glue to put together large Kubernetes deployments";
    homepage = "https://kluctl.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
  };
}
