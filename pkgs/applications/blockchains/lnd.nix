{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lnd";
  version = "0.10.3-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "129vi8z2sk4hagk7axa675nba6sbj9km88zlq8a1g8di7v2k9z6a";
  };

  vendorSha256 = "0a4bk2qry0isnrvl0adwikqn6imxwzlaq5j3nglb5rmwwq2cdz0r";

  subPackages = ["cmd/lncli" "cmd/lnd"];

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
