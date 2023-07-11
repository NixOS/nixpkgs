{ buildGoModule, fetchFromGitHub, lib, lightwalletd, testers }:

buildGoModule rec {
  pname = "lightwalletd";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "lightwalletd";
    rev = "v${version}";
    hash = "sha256-oFP1VHDhbx95QLGcIraHjeKSnLfvagJg4bcd3Lem+s4=";
  };

  vendorHash = "sha256-RojAxNU5ggjTMPDF2BuB4NyuSRG6HMe3amYTjG2PRFc=";

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
  };
}
