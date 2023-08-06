{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrwallet";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "release-v${version}";
    hash = "sha256-ffY5IvSGu4Q7EdJpfdsIKxxjkm6FD0DR9ItnaO90SBc=";
  };

  vendorHash = "sha256-dduHuMa5UPf73lfirTHSrYnOUbc2IyULpstZPGUJzuc=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "A secure Decred wallet daemon written in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
