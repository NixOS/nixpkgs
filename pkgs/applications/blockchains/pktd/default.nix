{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pktd";
  version = "1.4.0";

  # goPackagePath = "github.com/jpmorganchase/quorum";

  src = fetchFromGitHub {
    owner = "pkt-cash";
    repo = pname;
    rev = "pktd-v${version}";
    sha256 = "sha256-6tlRPxTgwSE4aUQx1ehd7DgM0pWHwkFibXZHhCcTxlI=";
  };

  vendorSha256 = "sha256-Hbn7C74L6WEJS9OIcAeJD+VK/GfvGEO33cUK1yvDyZA=";

  doCheck = false;

  meta = with lib; {
    description = "PKT full node and wallet";
    homepage = "https://pkt.cash/";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
