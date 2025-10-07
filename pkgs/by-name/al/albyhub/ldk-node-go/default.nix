{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ldkNode,
}:

buildGoModule {
  pname = "ldk-node-go";
  version = "0-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node-go";
    rev = "91db97badfc261f8c680cf64124914ef97d08d0d";
    hash = "sha256-7HbwMDLi1vRWMbUzx1bHyq/r+BwEejbz7SM1j/5SdmE=";
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
