{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "psw";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Wulfsta";
    repo = "psw";
    rev = version;
    sha256 = "sha256-Rf6vpVgenTzb42/aGqItuxUodl61eNyUPlry7rgLPbI=";
  };

  cargoHash = "sha256-dfHcyGQYkjEAhrNRlD5BTbMwaZaO/E0KwqZJ8TjelGw=";

  meta = {
    description = "Command line tool to write random bytes to stdout";
    homepage = "https://github.com/Wulfsta/psw";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ wulfsta ];
  };
}
