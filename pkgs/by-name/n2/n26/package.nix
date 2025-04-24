{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "n26";
  version = "unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "pasqui23";
    repo = "n26";
    rev = "ef079c2804f73dac053d02b22de64f4d1d96d9c2";
    hash = "sha256-COEUdm2AJKgAru+FWL72o+prkjwRsFygrO0Zas4GMJE=";
  };

  vendorHash = "sha256-7f5Ok8iqcGLZnUXwiIEDklQPFynklmmWxg/xbOv0qHc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "API and CLI to get information of your N26 account";
    homepage = "https://github.com/pasqui23/n26";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "n26";
  };
}
