{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "promql-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nalbury";
    repo = "promql-cli";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Command-line tool to query a Prometheus server with PromQL and visualize the output";
    homepage = "https://github.com/nalbury/promql-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "promql";
  };
}
