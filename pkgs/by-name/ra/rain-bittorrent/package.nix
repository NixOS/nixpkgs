{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+SiyqzEgdLYwgNCouprEFlv9eVW3H16p9K6cv8Oj4PQ=";
  };

  vendorHash = "sha256-6w3q6MZ0IdENKl7WpRdgAYIlOvmpbExURocpKPmwsDI=";

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
