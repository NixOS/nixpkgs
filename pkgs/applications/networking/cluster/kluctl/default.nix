{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-2nAgJj/cMDiE5rw/YixNYQNCWnuC/8EX4BrnXN4Npao=";
  };

  vendorHash = "sha256-xBUrY8v4yHtWGaaRXHxQRGdZHzMGoJX2hFLL+0Vb1QY=";

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
