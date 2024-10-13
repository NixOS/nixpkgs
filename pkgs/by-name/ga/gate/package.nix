{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  pname = "gate";
  version = "0.41.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    rev = "refs/tags/v${version}";
    hash = "sha256-tQO1ClfZasRdnazFOMOWeqnXaEda84lQMQKw5640YCI=";
  };

  vendorHash = "sha256-Nl6NGz+sEdwcTzbL+OwHuaQzi2lHX/cN2lE6HNi1uJQ=";

  ldflags = [ "-s" "-w" ];

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

