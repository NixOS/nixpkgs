{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chglog";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "chglog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LTw4juhuinz69kkBCftrzQU63gREhlAmAqs3KAotIKQ=";
  };

  vendorHash = "sha256-XP3zEtHcXtVDVNXX2WR7n+eXDBLoa5KAPf+RtToaWo8=";

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
