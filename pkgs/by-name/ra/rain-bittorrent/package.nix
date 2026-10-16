{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ePfJzHIADWdA6615VDNfzeI3yZ8MlX4ng7/xBKLCCi0=";
  };

  vendorHash = "sha256-mPx6krthOC5HdR3B7E+WmtZepewwPdNCGPCS4MWhty4=";

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
