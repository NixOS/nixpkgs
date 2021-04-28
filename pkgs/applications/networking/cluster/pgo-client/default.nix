{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgo-client";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = "postgres-operator";
    rev = "v${version}";
    sha256 = "sha256-zPFsLKbuVq2wMjFsqjBGiatPBwGR/X6q3mj8o5BE+r0=";
  };

  vendorSha256 = "sha256-DU1kc7YDQ+denj6tHVGt79s494aBFZ2KM7PVSn951KI=";

  subPackages = [ "cmd/pgo" ];

  meta = with lib; {
    description = "A CLI client for Crunchy PostgreSQL Kubernetes Operator";
    homepage = "https://github.com/CrunchyData/postgres-operator";
    changelog = "https://github.com/CrunchyData/postgres-operator/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
    platforms = platforms.linux;
  };
}
