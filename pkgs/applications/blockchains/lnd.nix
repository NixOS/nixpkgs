{ buildGoModule, fetchFromGitHub, stdenv, Security }:

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

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
