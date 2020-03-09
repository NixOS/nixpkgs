{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lnd";
  version = "0.9.0-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "1hq105s9ykp6nsn4iicjnl3mwspqkbfsswkx7sgzv3jggg08fkq9";
  };

  modSha256 = "1pvcvpiz6ck8xkgpypchrq9kgkik0jxd7f3jhihbgldsh4zaqiaq";

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
