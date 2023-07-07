{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.20.7";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-NcvPo+6f2EYhitzOl2VPz8MtFIsYBuOA7EJnD4TJdmI=";
  };

  vendorHash = "sha256-x5Zy8H7DzxU+uBCUL6edv8x2LwiIjXl5UrRUMDtUEk8=";

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
    maintainers = with maintainers; [ sikmir ];
  };
}
