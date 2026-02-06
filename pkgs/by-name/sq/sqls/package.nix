{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.45";

  src = fetchFromGitHub {
    owner = "sqls-server";
    repo = "sqls";
    rev = "v${version}";
    hash = "sha256-r9D3YtUk/hv3ex/PSGPTNIBTW3s3a3KdIBtxDry30Zc=";
  };

  vendorHash = "sha256-eh43G0fR+NRRXRPCfxjlwzzw3yg/ZRb1GpWwHGqyRrE=";

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
