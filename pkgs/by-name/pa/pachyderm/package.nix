{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-S3om62ibp/hbpoY6seJ7RaRQeAzDNsThqfGDFC0SEQM=";
  };

  vendorHash = "sha256-+4vegNCaDWaGwhEyk5msCuydC5IvQuGEatc1U1CZRjc=";

  subPackages = [ "src/server/cmd/pachctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pachyderm/pachyderm/v${lib.versions.major version}/src/version.AppVersion=${version}"
  ];

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = "https://www.pachyderm.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    mainProgram = "pachctl";
  };
}
