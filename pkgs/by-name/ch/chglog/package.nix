{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chglog";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "chglog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gDTZFUaaAnv/eJ9ZoygUNvfJE8PJc5vcGhd+Qown0SY=";
  };

  vendorHash = "sha256-1IZJ/Mq1Oskm7UU0IYfGtOHBFwIzpTLn68OSD0K8hyM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.builtBy=nixpkgs"
  ];

  meta = {
    description = "Changelog management library and tool";
    homepage = "https://github.com/goreleaser/chglog";
    changelog = "https://github.com/goreleaser/chglog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wineee ];
    mainProgram = "chglog";
  };
})
