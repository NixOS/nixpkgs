{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chglog";
<<<<<<< HEAD
  version = "0.7.4";
=======
  version = "0.7.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "chglog";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gDTZFUaaAnv/eJ9ZoygUNvfJE8PJc5vcGhd+Qown0SY=";
  };

  vendorHash = "sha256-1IZJ/Mq1Oskm7UU0IYfGtOHBFwIzpTLn68OSD0K8hyM=";
=======
    hash = "sha256-PULQNe7V18NMxmIgvId1cFU1DuSbNeDk4cB1aMx3OHc=";
  };

  vendorHash = "sha256-kw6vOxqBvHfD5ooJsufX2xpUCFKWzThKzpBBNKL60Ko=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
