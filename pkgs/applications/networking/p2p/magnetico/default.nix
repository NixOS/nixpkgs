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

  vendorSha256 = "0g4m0jnpy0q64xnflphyc0lmhni0q9448h7grbbr7f1s9lpqsjml";

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
    homepage     = "https://github.com/boramalper/magnetico";
    license      = licenses.agpl3;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
