{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZU++Ue/KrLorsXBvnEBzOl/P+D1V6/zMEVZ1m4pCY0A=";
  };

  vendorHash = "sha256-JVsi3Wb7n+D9A4VmwbO8bYwWNsc6nmcKVhk/qzU14Gw=";

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
