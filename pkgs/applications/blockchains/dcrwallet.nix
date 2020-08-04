{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrwallet";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrwallet";
    rev = "refs/tags/v${version}";
    sha256 = "0ij2mwvdxg78p9qbdf9wm7aaphfg4j8lqgrjyjsj3kyi1l458ds9";
  };

  vendorSha256 = "0qrrr92cad399xwr64qa9h41wqqaj0dy5mw248g5v53zars541w7";

  subPackages = [ "." ];

  meta = {
    homepage = "https://decred.org";
    description = "A secure Decred wallet daemon written in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
