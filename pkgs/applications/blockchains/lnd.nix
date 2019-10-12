{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lnd";
  version = "0.7.1-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "1c0sm0lavdai4w6d283q54knggw9d42vvqmglnv2h9swbw1l23ry";
  };

  modSha256 = "13hjaf4bswk8g57lyxzdlqqp4a6ddl3qm6n4jja4b1h58mlbil73";

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
