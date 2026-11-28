{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ldkNode,
}:

buildGoModule {
  pname = "ldk-node-go";
  version = "0-unstable-2026-11-18";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node-go";
    rev = "d98e7ace35be33f2d1a3350a00c7c5666f5bfa89";
    hash = "sha256-Y1denvXvcw/DIyHZ2SguI3qUVOqCFtrmBj4tJ54I6tY=";
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
