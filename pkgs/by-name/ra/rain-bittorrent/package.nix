{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bl9d3U3ztjHnTB3tUNe/k9n4z0THXMLmC0/wzBiaGMw=";
  };

  vendorHash = "sha256-hmBUvtLtbWa/a2Ah1mr1rsZxxFT3xY0Sy6uHVyTMljw=";

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
})
