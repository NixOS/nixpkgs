{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "hexxy";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "sweetbbak";
    repo = "hexxy";

    tag = "v${finalAttrs.version}";
    hash = "sha256-pboOpPGqlSWSiP6yWONxC3wbrGc8FN0++5vHd4ERbkA=";
  };

  vendorHash = "sha256-qkBpSVLWZPRgS9bqOVUWHpyj8z/nheQJON3vJOwPUj4=";
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern and beautiful alternative to xxd and hexdump";
    homepage = "https://github.com/sweetbbak/hexxy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.NotAShelf ];
    mainProgram = "hexxy";
  };
})
