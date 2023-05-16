{ buildGoModule, fetchFromGitHub, lib, lightwalletd, testers }:

buildGoModule rec {
  pname = "lightwalletd";
<<<<<<< HEAD
  version = "0.4.16";
=======
  version = "0.4.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "lightwalletd";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-M9xfV2T8L+nssrJj29QmPiErNMpfpT8BY/30Vj8wPjY=";
  };

  vendorHash = "sha256-z5Hs+CkPswWhz+Ya5MyHKA3MZzQkvS7WOxNckElkg6U=";
=======
    rev = "68789356fb1a75f62735a529b38389ef08ea7582";
    sha256 = "sha256-7gZhr6YMarGdgoGjg+oD4nZ/SAJ5cnhEDKmA4YMqJTo=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
=======
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
