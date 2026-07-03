{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "nexusd";
  version = "3.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gammazero";
    repo = "nexus";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-c9y1NplODCIz+IZlZAyzm3G75D1wawTwbB6SZXZqjXc=";
  };

  vendorHash = "sha256-1sZDoDcX/9upTZ8bL7l+ldsouBZVT+61RFSRaeB6Dm8=";

  subPackages = [ "nexusd" ];

  meta = {
    description = "Full-feature WAMP v2 router written in Go";
    homepage = "https://github.com/gammazero/nexus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "nexusd";
    platforms = lib.platforms.unix;
  };
})
