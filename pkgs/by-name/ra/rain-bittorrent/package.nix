{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${version}";
    hash = "sha256-hXNup0ROW+0jFqMzC1bF48XZIIyzy7/jWepEp1sPF0Q=";
  };

  vendorHash = "sha256-e7adl7B2TFjkVlA2YQ3iXQRMhHThJHWOLPphmhdEmTE=";

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
