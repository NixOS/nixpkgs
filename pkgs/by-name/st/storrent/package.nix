{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "storrent";
  version = "0-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "storrent";
    rev = "7d7d956c3b7bc1c51a2a4ed5b6925d717fc280ff";
    hash = "sha256-yAWKz85EqIJis+K4qP+5aOnx2YrhRx0+LPAAEawUUsU=";
  };

  vendorHash = "sha256-/m+U4UsofU0vOFMh+omRzn/DWqr3ghgIl+a4v1foGjY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/jech/storrent";
    description = "Implementation of the BitTorrent protocol that is optimised for streaming media";
    mainProgram = "storrent";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
