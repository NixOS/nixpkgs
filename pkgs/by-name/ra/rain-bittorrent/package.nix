{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${version}";
    hash = "sha256-phBZ1hIH6o4q8CU6+dheZG78OcO+e7YvJoC6hyHHNb4=";
  };

  vendorHash = "sha256-U4NZR3vJRLTrhE1CoCAB+7pkVnvxlJpbLmIGMFuZzWc=";

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
