{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "beads";
  version = "0.24.5";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = "beads";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LKTdeOF1O/hV0kdP9ASTw+IG0T3tNuI+vcrD/8dxJMc=";
  };

  vendorHash = "sha256-5p4bHTBB6X30FosIn6rkMDJoap8tOvB7bLmVKsy09D8=";

  subPackages = [ "cmd/bd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require the bd binary to be in PATH
  doCheck = false;

  meta = {
    description = "Lightweight memory system for AI coding agents with graph-based issue tracking";
    homepage = "https://github.com/steveyegge/beads";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "bd";
  };
})
