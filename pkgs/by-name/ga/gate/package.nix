{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "gate";
  version = "0.47.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${version}";
    hash = "sha256-bEpEE7W2emKLgN8WZ2Jw/cHI8ipX8mo3NZLgxUyuMK4=";
  };

  vendorHash = "sha256-ZxrQIcuTVROuRevQty2HN0J9NnOVkk9t8PvUZyxof1Y=";

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
