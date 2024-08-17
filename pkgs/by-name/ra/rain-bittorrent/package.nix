{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "rain";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    rev = "v1.13.0";
    sha256 = "sha256-pz20vhr3idXja7wYIdVr1dosSpqYiQfeho66rqd718I=";
  };

  vendorHash = "sha256-40DK0D9TRJDfrMbBJNpcNzvjKb/uXN/Yz5Bb7oXBh+E=";

  meta = with lib; {
    description = "BitTorrent client and library in Go";
    homepage = "https://github.com/cenkalti/rain";
    license = licenses.mit;
    maintainers = with maintainers; [ justinrubek ];
    mainProgram = "rain";
  };
}
