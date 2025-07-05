{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "goconvey";
  version = "1.8.1-unstable-2024-03-06";

  excludedPackages = "web/server/watch/integration_testing";

  src = fetchFromGitHub {
    owner = "smartystreets";
    repo = "goconvey";
    rev = "a50310f1e3e53e63e2d23eb904f853aa388a5988";
    hash = "sha256-w5eX/n6Wu2gYgCIhgtjqH3lNckWIDaN4r80cJW3JqFo=";
  };

  vendorHash = "sha256-P4J/CZY95ks08DC+gSqG+eanL3zoiaoz1d9/ZvBoc9Q=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [
    "-short"
  ];

  meta = {
    description = "Go testing in the browser. Integrates with `go test`. Write behavioral tests in Go";
    mainProgram = "goconvey";
    homepage = "https://github.com/smartystreets/goconvey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
