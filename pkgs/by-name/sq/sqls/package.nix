{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.32";

  src = fetchFromGitHub {
    owner = "sqls-server";
    repo = "sqls";
    rev = "v${version}";
    hash = "sha256-dbRc/OGs5U1DLWBsENTrjt4wf26ZBy/4jWt1PuiLfi4=";
  };

  vendorHash = "sha256-BSGKFSw/ReeADnB3FuEJoxstkCcJx434vNaFf5A+Gbw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.revision=${src.rev}"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/sqls-server/sqls";
    description = "SQL language server written in Go";
    mainProgram = "sqls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
  };
}
