{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${version}";
    hash = "sha256-qR9iwE4EpTCsDhbU8mxalGDK31lneN1HPiXOBfhiZas=";
  };

  vendorHash = "sha256-j8IVymRwhLZ2EDJtmNGgFfQ0KOmLvClDCeMjvq5KagM=";

  meta = {
    description = "BitTorrent client and library in Go";
    homepage = "https://github.com/cenkalti/rain";
    license = lib.licenses.mit;
    mainProgram = "rain";
    maintainers = with lib.maintainers; [
      justinrubek
      matthewdargan
    ];
  };
}
