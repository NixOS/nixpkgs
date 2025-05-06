{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "gate";
  version = "0.48.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${version}";
    hash = "sha256-e6NJlKAo9Y2HGcOF3rfystTRerqgicKVZ+1g2zsQq9g=";
  };

  vendorHash = "sha256-gho3OJvDTRTHg+ITCvR49oq9pBUZj7i7rtpSIctmTcY=";

  ldflags = [
    "-s"
    "-w"
  ];

  excludedPackages = [ ".web" ];

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
