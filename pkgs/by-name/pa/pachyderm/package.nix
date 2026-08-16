{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "pachyderm";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S3om62ibp/hbpoY6seJ7RaRQeAzDNsThqfGDFC0SEQM=";
  };

  vendorHash = "sha256-+4vegNCaDWaGwhEyk5msCuydC5IvQuGEatc1U1CZRjc=";

  subPackages = [ "src/server/cmd/pachctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pachyderm/pachyderm/v${lib.versions.major finalAttrs.version}/src/version.AppVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "Containerized Data Analytics";
    homepage = "https://www.pachyderm.com/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pachctl";
  };
})
