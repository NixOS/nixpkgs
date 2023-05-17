{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.19.3";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-yp471eWrwnJiCAVwqnZzq1rN1Mt4d42ymVvsUtTyOsc=";
  };

  vendorHash = "sha256-Ws0Qaw2hk8alOF/K5Wd0ZcMGr6Q3JiQIo/kHOXiGvmg=";

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
