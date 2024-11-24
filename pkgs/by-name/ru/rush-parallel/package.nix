{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rush-parallel";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    rev = "v${version}";
    hash = "sha256-xwU6ZPGhaMxIsowTxWUxMDXO7hlWg2KynGGDX1dMZmo=";
  };

  vendorHash = "sha256-zCloMhjHNkPZHYX1e1nx072IYbWHFWam4Af0l0s8a6M=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A cross-platform command-line tool for executing jobs in parallel";
    homepage = "https://github.com/shenwei356/rush";
    changelog = "https://github.com/shenwei356/rush/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "rush-parallel";
  };
}
