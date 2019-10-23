{ lib, fetchFromGitHub, buildGoModule, go-bindata }:

buildGoModule rec {
  pname = "magnetico";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner  = "boramalper";
    repo   = "magnetico";
    rev    = "v${version}";
    sha256 = "1f7y3z9ql079ix6ycihkmd3z3da3sfiqw2fap31pbvvjs65sg644";
  };

  modSha256 = "1h9fij8mxlxfw7kxix00n10fkhkvmf8529fxbk1n30cxc1bs2szf";

  buildInputs = [ go-bindata ];
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
