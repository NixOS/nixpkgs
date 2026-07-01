{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PrzpaFGi4uGIXQ/L8dgJl7NrLD2SQwuI2vfCq2NPLLg=";
  };

  vendorHash = "sha256-/OjWPt4X4xfcFgX8H2dd2T/wl/wH9Nz1l0uA2Ejd21Q=";

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
