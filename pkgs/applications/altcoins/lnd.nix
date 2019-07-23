{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lnd";
  version = "0.7.0-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "0d6m1vfy33rg6d7qmkpydiypav1girxsnxan9njyjz0vhinmq0sx";
  };

  modSha256 = "0akxi7xhyz7xx0vc003abidva02sp940cc2gfjg4fmzkc95cajc9";

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
