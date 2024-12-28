{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ldkNode,
}:

buildGoModule rec {
  pname = "ldk-node-go";
  version = "8911834564db720e9b22950441df706d69622d81";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node-go";
    rev = version;
    hash = "sha256-vjXpvjPZlxOiTrcEbQW8YTnpQx7XbmPqYda+8UYyUvE=";
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
    license = lib.licenses.unlicense; # https://github.com/getAlby/ldk-node-go/issues/27
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}
