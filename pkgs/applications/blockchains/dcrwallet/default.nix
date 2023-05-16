{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrwallet";
<<<<<<< HEAD
  version = "1.8.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
<<<<<<< HEAD
    rev = "release-v${version}";
    hash = "sha256-ffY5IvSGu4Q7EdJpfdsIKxxjkm6FD0DR9ItnaO90SBc=";
  };

  vendorHash = "sha256-dduHuMa5UPf73lfirTHSrYnOUbc2IyULpstZPGUJzuc=";
=======
    rev = "refs/tags/v${version}";
    sha256 = "sha256-WUfmv+laOwR/fc4osAFzPKqHQR+wOtSdLEsysICnuvg=";
  };

  vendorSha256 = "sha256-9IRNlULvARIZu6dWaKrvx6fiDJ80SBLINhK/9tW9k/0=";

  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "A secure Decred wallet daemon written in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
