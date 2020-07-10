{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lnd";
  version = "0.10.0-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "1amciz924s2h6qhy7w34jpv1jc25p5ayfxzvjph6hhx0bccrm88w";
  };

  vendorSha256 = "1iyghg11cxvbzi0gl40fvv8pl3d3k52j179w3x5m1f09r5ji223y";

  subPackages = ["cmd/lncli" "cmd/lnd"];

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}