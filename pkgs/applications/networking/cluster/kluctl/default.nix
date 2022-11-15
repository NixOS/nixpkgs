{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-rcwtVhtLc49rD6J3AZFumLQrZuTveE7OY+agufe/4MQ=";
  };

  vendorHash = "sha256-IC+sjctDqd0lQD5labl+UYWsRiptQKSjSHYf2SGkp14=";

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
