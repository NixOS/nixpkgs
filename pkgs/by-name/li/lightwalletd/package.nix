{
  buildGoModule,
  fetchFromGitHub,
  lib,
  lightwalletd,
  testers,
}:

buildGoModule rec {
  pname = "lightwalletd";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "lightwalletd";
    rev = "v${version}";
    hash = "sha256-vlfC/2yuHx9wiOczyUfBmuI5KdLyonACVlwtUowSuDA=";
  };

  vendorHash = "sha256-DT1R6C6AoXR0FpyVTzw9VcF0DaPbvqvkrVsYg+6bP2g=";

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

  meta = {
    description = "Backend service that provides a bandwidth-efficient interface to the Zcash blockchain";
    homepage = "https://github.com/zcash/lightwalletd";
    maintainers = with lib.maintainers; [ centromere ];
    license = lib.licenses.mit;
    mainProgram = "lightwalletd";
  };
}
