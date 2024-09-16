{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  pname = "gate";
  version = "0.40.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    rev = "refs/tags/v${version}";
    hash = "sha256-zEbkt38/K4LVLVXXqaLU83mX94vI/dbZ+JqOjn2u0/c=";
  };

  vendorHash = "sha256-W3YBIbxblxO5Rirso+b20h4cwUzfj8rG/Owh1KyJ0mM=";

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

