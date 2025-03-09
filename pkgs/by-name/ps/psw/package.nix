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
    repo = pname;
    rev = version;
    sha256 = "sha256-Rf6vpVgenTzb42/aGqItuxUodl61eNyUPlry7rgLPbI=";
  };

  cargoHash = "sha256-+0eMhOteNK3QTnG0HB3/TYDFmPTztdQ0h3RKBTN0J/o=";

  meta = with lib; {
    description = "Command line tool to write random bytes to stdout";
    homepage = "https://github.com/Wulfsta/psw";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ wulfsta ];
  };
}
