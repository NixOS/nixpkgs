{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sqls";
  version = "0.2.48";

  src = fetchFromGitHub {
    owner = "sqls-server";
    repo = "sqls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TjGu8QcwYIPoW2v61fXpq/oZKoksOUZ2/dnleJhPjFM=";
  };

  vendorHash = "sha256-VVa77h0mgWLEuL2+Q3qre5V71kbBaWaugNN9TcTC8y0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.revision=${finalAttrs.src.rev}"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/sqls-server/sqls";
    description = "SQL language server written in Go";
    mainProgram = "sqls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
  };
})
