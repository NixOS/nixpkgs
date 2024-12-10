{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "gate";
  version = "0.36.7";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    rev = "refs/tags/v${version}";
    hash = "sha256-WHxpx20O/HuCWqbY4zTxcjyIhW3+FQtTz5sUGAda71g=";
  };

  vendorHash = "sha256-dswNJQWqN+u/mnpbj9se2j9uEi0ewNTXVlN3WnNbcyg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "High-Performance, Low-Memory, Lightweight, Extensible Minecraft Reverse Proxy";
    longDescription = ''
      Gate is an extensible, high performant & paralleled Minecraft proxy server
      with scalability, flexibility & excellent server version support - written in Go
      and ready for the cloud!
    '';
    homepage = "https://github.com/minekube/gate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ XBagon ];
    mainProgram = "gate";
  };
}
