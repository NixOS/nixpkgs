{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.30";

  src = fetchFromGitHub {
    owner = "sqls-server";
    repo = "sqls";
    rev = "v${version}";
    hash = "sha256-vsU0EZZ7Wwo2esv7StmSB4DbQXCwp4Mi+KsylCL0WcM=";
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
