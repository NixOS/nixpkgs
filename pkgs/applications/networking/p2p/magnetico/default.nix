{ lib, fetchFromGitHub, buildGoModule, go-bindata }:

buildGoModule rec {
  pname = "magnetico";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner  = "boramalper";
    repo   = "magnetico";
    rev    = "v${version}";
    sha256 = "1flw7r8igc0hhm288p67lpy9aj1fnywva5b28yfknpw8g97c9r5x";
  };

  modSha256 = "1h9fij8mxlxfw7kxix00n10fkhkvmf8529fxbk1n30cxc1bs2szf";

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
