{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gh-s";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-s";
    rev = "v${version}";
    hash = "sha256-hLfaAtWiJHCJ7MFz8dg4SJJB2cNY1gKUEwMAdRB4lr8=";
  };

  vendorHash = "sha256-5UJAgsPND6WrOZZ5PUZNdwd7/0NPdhD1SaZJzZ+2VvM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Search github repositories interactively";
    homepage = "https://github.com/gennaro-tedesco/gh-s";
    license = licenses.asl20;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "gh-s";
  };
}
