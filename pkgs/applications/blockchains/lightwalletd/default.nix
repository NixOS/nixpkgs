{
  buildGoModule,
  fetchFromGitHub,
  lib,
  lightwalletd,
  testers,
}:

buildGoModule rec {
  pname = "lightwalletd";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "lightwalletd";
    rev = "v${version}";
    hash = "sha256-M9xfV2T8L+nssrJj29QmPiErNMpfpT8BY/30Vj8wPjY=";
  };

  vendorHash = "sha256-z5Hs+CkPswWhz+Ya5MyHKA3MZzQkvS7WOxNckElkg6U=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zcash/lightwalletd/common.Version=v${version}"
    "-X github.com/zcash/lightwalletd/common.GitCommit=${src.rev}"
    "-X github.com/zcash/lightwalletd/common.BuildDate=1970-01-01"
    "-X github.com/zcash/lightwalletd/common.BuildUser=nixbld"
  ];

  excludedPackages = [
    "genblocks"
    "testclient"
    "zap"
  ];

  passthru.tests.version = testers.testVersion {
    package = lightwalletd;
    command = "lightwalletd version";
    version = "v${lightwalletd.version}";
  };

  meta = with lib; {
    description = "A backend service that provides a bandwidth-efficient interface to the Zcash blockchain";
    homepage = "https://github.com/zcash/lightwalletd";
    maintainers = with maintainers; [ centromere ];
    license = licenses.mit;
    mainProgram = "lightwalletd";
  };
}
