{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hexxy";
  version = "0.1.1-unstable-2025-03-24";
  src = fetchFromGitHub {
    owner = "sweetbbak";
    repo = "hexxy";
    # upstream does not publish releases, i.e., there are no tags
    rev = "8833335e497069247f330444ddbd64c5ddaa1b36";
    hash = "sha256-pboOpPGqlSWSiP6yWONxC3wbrGc8FN0++5vHd4ERbkA=";
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
