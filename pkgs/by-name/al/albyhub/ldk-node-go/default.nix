{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ldkNode,
}:

buildGoModule rec {
  pname = "ldk-node-go";
  version = "0-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node-go";
    rev = "ca26307fa2d8ee4d30da9affd0b202897f9919f6";
    hash = "sha256-UdsfN6UL9lKPQSCfF8oA89U0M3pqj/TcFcs01E7WoXs=";
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
