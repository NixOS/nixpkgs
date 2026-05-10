{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "r53-ddns";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "fleaz";
    repo = "r53-ddns";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+vJrcRxckAISYjab6kVT2mpChra1D3NflOqNWCch15I=";
  };

  vendorHash = "sha256-ImV/jxCYIWObN+jCSbXhuzR4TuRc/EgQ8SIV6x+wEpA=";

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/fleaz/r53-ddns";
    description = "DIY DynDNS tool based on Route53";
    maintainers = with lib.maintainers; [ fleaz ];
    mainProgram = "r53-ddns";
  };
})
