{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hexxy";
  version = "0-unstable-2025-03-16";
  src = fetchFromGitHub {
    owner = "sweetbbak";
    repo = "hexxy";
    # upstream does not publish releases, i.e., there are no tags
    rev = "d90f345ba80078b18baf006b3a5aec92d2c330e1";
    hash = "sha256-htTGdcJ3oMgfsJ3FH1aRnI2vxMNpBcLksABA75EQUFo=";
  };

  vendorHash = "sha256-qkBpSVLWZPRgS9bqOVUWHpyj8z/nheQJON3vJOwPUj4=";
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "A modern and beautiful alternative to xxd and hexdump";
    homepage = "https://github.com/sweetbbak/hexxy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.NotAShelf ];
    mainProgram = "hexxy";
  };
}
