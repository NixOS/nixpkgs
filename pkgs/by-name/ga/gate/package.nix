{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  pname = "gate";
  version = "0.37.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    rev = "refs/tags/v${version}";
    hash = "sha256-TsyiAPhSjz7xzvxx6EJswwUasMr/GCf+QXcSFgaG1Ko=";
  };

  vendorHash = "sha256-Ls99x08erFM6iP0UlMteafD4FCiq6HMF2ME89jyOEdE=";

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

