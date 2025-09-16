{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "r53-ddns";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "fleaz";
    repo = "r53-ddns";
    rev = "v${version}";
    sha256 = "sha256-+vJrcRxckAISYjab6kVT2mpChra1D3NflOqNWCch15I=";
  };

  vendorHash = "sha256-ImV/jxCYIWObN+jCSbXhuzR4TuRc/EgQ8SIV6x+wEpA=";

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/fleaz/r53-ddns";
    description = "DIY DynDNS tool based on Route53";
    maintainers = with maintainers; [ fleaz ];
    mainProgram = "r53-ddns";
  };
}
