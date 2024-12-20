{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ircdog";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "goshuirc";
    repo = "ircdog";
    rev = "refs/tags/v${version}";
    hash = "sha256-maF53Z0FHAhGmnOnMsX0dDnmckPNBY4Bcm4OBM/x4hQ=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "ircdog is a simple wrapper over the raw IRC protocol that can respond to pings, and interprets formatting codes";
    mainProgram = "ircdog";
    homepage = "https://github.com/ergochat/ircdog";
    changelog = "https://github.com/ergochat/ircdog/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}
