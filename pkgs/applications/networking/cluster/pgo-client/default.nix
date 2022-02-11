{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgo-client";
  version = "4.7.4";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = "postgres-operator";
    rev = "v${version}";
    sha256 = "sha256-8L3eFMATCGIM6xxUM7mi/D3njHMFk7cgPLJotilAS5k=";
  };

  vendorSha256 = "sha256-4Vz7Lioj6iLU7dbz/B2BSAgfaCl2MyC8MM9yiyWLi2o=";

  subPackages = [ "cmd/pgo" ];

  meta = with lib; {
    description = "A CLI client for Crunchy PostgreSQL Kubernetes Operator";
    homepage = "https://github.com/CrunchyData/postgres-operator";
    changelog = "https://github.com/CrunchyData/postgres-operator/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
