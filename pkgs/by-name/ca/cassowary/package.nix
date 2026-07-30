{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cassowary";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = "cassowary";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-27sEexOGLQ42qWY+vCiPTt5XR66TSUvKsuGgtkbMgE4=";
  };

  vendorHash = "sha256-YP9q9lL2A9ERhzbJBIFKsYsgvy5xYeUO3ekyQdh97f8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hugoreeves ];
    mainProgram = "cassowary";
  };
})
