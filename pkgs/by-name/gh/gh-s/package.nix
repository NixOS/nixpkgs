{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gh-s";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-s";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+jAJicvk6N2PfOTBR5H9nP3xTiBq4oYfNLvxN4sKvh4=";
  };

  vendorHash = "sha256-5UJAgsPND6WrOZZ5PUZNdwd7/0NPdhD1SaZJzZ+2VvM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Search github repositories interactively";
    homepage = "https://github.com/gennaro-tedesco/gh-s";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "gh-s";
  };
})
