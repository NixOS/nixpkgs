{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ldkNode,
}:

buildGoModule rec {
  pname = "ldk-node-go";
  version = "v0.0.0-20250521134242-ca26307fa2d8";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node-go";
    rev = "v0.0.0-20250521134242-ca26307fa2d8";
    hash = lib.fakeHash;
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
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}
