{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrwallet";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-WUfmv+laOwR/fc4osAFzPKqHQR+wOtSdLEsysICnuvg=";
  };

  vendorSha256 = "sha256-9IRNlULvARIZu6dWaKrvx6fiDJ80SBLINhK/9tW9k/0=";

  doCheck = false;

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "A secure Decred wallet daemon written in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
