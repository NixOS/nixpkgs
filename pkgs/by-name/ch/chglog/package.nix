{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chglog";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "chglog";
    tag = "v${version}";
    hash = "sha256-PULQNe7V18NMxmIgvId1cFU1DuSbNeDk4cB1aMx3OHc=";
  };

  vendorHash = "sha256-kw6vOxqBvHfD5ooJsufX2xpUCFKWzThKzpBBNKL60Ko=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.builtBy=nixpkgs"
  ];

  meta = {
    description = "Changelog management library and tool";
    homepage = "https://github.com/goreleaser/chglog";
    changelog = "https://github.com/goreleaser/chglog/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wineee ];
    mainProgram = "chglog";
  };
}
