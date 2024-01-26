{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.22.1";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-s7ADEWy3wx2hGeJzfXPVSBv+bAOoOQPsF75Sq02T/AI=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "sha256-EEOVd15f1SK8InSIG+TuVwWibkf+ePJ5AGZpiMD+RaQ=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  # Depends on docker
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = kluctl;
    version = "v${version}";
  };

  postInstall = ''
    mv $out/bin/{cmd,kluctl}
  '';

  meta = with lib; {
    description = "The missing glue to put together large Kubernetes deployments";
    homepage = "https://kluctl.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir netthier ];
  };
}
