{ buildGoModule, fetchFromGitHub, lib, lightwalletd, testers }:

buildGoModule rec {
  pname = "lightwalletd";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "lightwalletd";
    rev = "68789356fb1a75f62735a529b38389ef08ea7582";
    sha256 = "sha256-7gZhr6YMarGdgoGjg+oD4nZ/SAJ5cnhEDKmA4YMqJTo=";
  };

  vendorSha256 = null;

  ldflags = [
    "-s" "-w"
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
