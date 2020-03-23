{ lib, fetchFromGitHub, buildGoModule, go-bindata }:

buildGoModule rec {
  pname = "magnetico";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner  = "boramalper";
    repo   = "magnetico";
    rev    = "v${version}";
    sha256 = "1622xcl5v67lrnkjwbg7g5b5ikrawx7p91jxbj3ixc1za2f3a3fn";
  };

  modSha256 = "193n323xaypm9xkpray68nqcgyf141x8qzpxzwjnrmsgfz8p6wgk";

  nativeBuildInputs = [ go-bindata ];
  buildPhase = ''
    make magneticow magneticod
  '';

  doCheck = true;
  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description  = "Autonomous (self-hosted) BitTorrent DHT search engine suite.";
    homepage     = https://github.com/boramalper/magnetico;
    license      = licenses.agpl3;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
