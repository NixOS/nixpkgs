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

  modSha256 = "15i4h3pkvyav9qsbfinzifram0knkylg24j6j0mxs4bnj80j4ycm";

  subPackages = ["cmd/lncli" "cmd/lnd"];

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
