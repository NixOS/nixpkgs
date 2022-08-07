{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgo-client";
  version = "4.7.5";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = "postgres-operator";
    rev = "v${version}";
    sha256 = "sha256-1GYpvw3ch03Cx4BReNwLnbgbds4uuSe/cjvbHuRhLOw=";
  };

  vendorSha256 = "sha256-5/mLlgNdlX/ABrpofPqowCskxFwJAEKVpbsMOvMvTWc=";

  subPackages = [ "cmd/pgo" ];

  meta = with lib; {
    description = "A CLI client for Crunchy PostgreSQL Kubernetes Operator";
    homepage = "https://github.com/CrunchyData/postgres-operator";
    changelog = "https://github.com/CrunchyData/postgres-operator/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
    mainProgram = "pgo";
  };
}
