{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    rev = "refs/tags/v${version}";
    hash = "sha256-pz20vhr3idXja7wYIdVr1dosSpqYiQfeho66rqd718I=";
  };

  vendorHash = "sha256-40DK0D9TRJDfrMbBJNpcNzvjKb/uXN/Yz5Bb7oXBh+E=";

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
