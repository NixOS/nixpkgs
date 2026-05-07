{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "promql-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nalbury";
    repo = "promql-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EV63fdG+GF+kVLH2TxHPhRcUU5xBvkW5bhHC1lEoj84=";
  };

  vendorHash = "sha256-jhNll04xGaxS6NJTh4spSW9zPrff8jk5OEQiRevPQwU=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv -v $out/bin/promql-cli $out/bin/promql
  '';

  meta = {
    description = "Command-line tool to query a Prometheus server with PromQL and visualize the output";
    homepage = "https://github.com/nalbury/promql-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "promql";
  };
})
