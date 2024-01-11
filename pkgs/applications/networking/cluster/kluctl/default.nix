{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-wT40MgvXl32jHq+k0nYaPnAcfLBMxRMiN5CYVXM2PYM=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "sha256-dGuB68y/JsmfBZLGPgGbGgdRPzVWzveOLjFXOKMp7GY=";

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
