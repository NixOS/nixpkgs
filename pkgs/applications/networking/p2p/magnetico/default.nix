{ lib, fetchFromGitHub, buildGoModule, go-bindata }:

buildGoModule rec {
  pname = "magnetico";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner  = "boramalper";
    repo   = "magnetico";
    rev    = "v${version}";
    sha256 = "1avqnfn4llmc9xmpsjfc9ivki0cfvd8sljfzd9yac94xcj581s83";
  };

  vendorSha256 = "087kikj6sjhjxqymnj7bpxawfmwckihi6mbmi39w0bn2040aflx5";

  nativeBuildInputs = [ go-bindata ];
  buildPhase = ''
    make magneticow magneticod
  '';

  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description  = "Autonomous (self-hosted) BitTorrent DHT search engine suite";
    homepage     = "https://github.com/boramalper/magnetico";
    license      = licenses.agpl3;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
