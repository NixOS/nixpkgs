{
  buildGoModule,
  fetchFromGitHub,
  lib,
  lightwalletd,
  testers,
}:

buildGoModule rec {
  pname = "lightwalletd";
  version = "0.4.18";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "lightwalletd";
    rev = "v${version}";
    hash = "sha256-YmSQjfqwTZC3NkPH6k7gwHcaYRURive5rc0MVOKWCi8=";
  };

  vendorHash = "sha256-jAsX+BhVYbD/joCMT2vdDdRLqZOG9AfXmbRPJcJcQEw=";

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
    description = "Backend service that provides a bandwidth-efficient interface to the Zcash blockchain";
    homepage = "https://github.com/zcash/lightwalletd";
    maintainers = with maintainers; [ centromere ];
    license = licenses.mit;
    mainProgram = "lightwalletd";
  };
}
