{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "gate";
  version = "0.52.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${version}";
    hash = "sha256-DKnJnhfO3Cs80tAYiodxf1alfO4DXNneiqDILgP+v8w=";
  };

  vendorHash = "sha256-0NcfuCZHR4QHbMNqc+ilPouie+9k7FqOG/JdNX8uO8c=";

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
