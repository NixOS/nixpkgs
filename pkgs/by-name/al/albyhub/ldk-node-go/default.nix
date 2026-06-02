{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ldkNode,
}:

buildGoModule {
  pname = "ldk-node-go";
  version = "0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node-go";
    rev = "3690cdb3031c75f0ee0a67222c2db3c69fea8f2c";
    hash = "sha256-OlJGHhal5fkR0r0FtsVbG1aILZSTLsSRcqrZ84pIRLU=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [
    ldkNode
  ];

  propagatedBuildInputs = [ ldkNode ];

  meta = {
    description = "Experimental Go bindings for LDK-node";
    homepage = "https://github.com/getAlby/ldk-node-go";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}
