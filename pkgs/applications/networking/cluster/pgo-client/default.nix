{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgo-client";
  version = "4.7.7";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = "postgres-operator";
    rev = "v${version}";
    sha256 = "sha256-rHWCj25NEKbwV1kmuH6k3oWSXKelknb2GRDgLaZSb3U=";
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
