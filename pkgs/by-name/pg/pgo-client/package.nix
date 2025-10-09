{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgo-client";
  version = "4.7.10";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = "postgres-operator";
    rev = "v${version}";
    sha256 = "sha256-ZwKfbmKPvhxLpCGH+IlfoQjnw8go4N6mfseY2LWCktA=";
  };

  vendorHash = "sha256-qpS1TLShJwXgmtuhWIPOlcHMofUgOWZ8vbri36i+hpM=";

  subPackages = [ "cmd/pgo" ];

  meta = {
    description = "CLI client for Crunchy PostgreSQL Kubernetes Operator";
    homepage = "https://github.com/CrunchyData/postgres-operator";
    changelog = "https://github.com/CrunchyData/postgres-operator/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bryanasdev000 ];
    mainProgram = "pgo";
  };
}
