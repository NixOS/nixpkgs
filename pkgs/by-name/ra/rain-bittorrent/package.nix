{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${version}";
    hash = "sha256-6Y+q7up6JyzBM4qov3k4l/ZUP7XsGVXvG0C6VKA/42g=";
  };

  vendorHash = "sha256-SX686l6fsr3Gm+gyzNUZUSGXwAnxaTvUo/J57N10fmU=";

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
