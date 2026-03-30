{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ircdog";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "goshuirc";
    repo = "ircdog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-maF53Z0FHAhGmnOnMsX0dDnmckPNBY4Bcm4OBM/x4hQ=";
  };

  vendorHash = null;

  meta = {
    description = "Simple wrapper over the raw IRC protocol that can respond to pings, and interprets formatting codes";
    mainProgram = "ircdog";
    homepage = "https://github.com/ergochat/ircdog";
    changelog = "https://github.com/ergochat/ircdog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
