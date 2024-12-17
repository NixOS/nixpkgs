{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-GR5EjVd1Tje9FLyP0pfNT6hMUGYkfPnsT8M72H713D4=";
  };

  vendorHash = "sha256-rh+b089fr+z0YzgvzivzELnSbNDiNczGCRwFrIYR250=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${version}'"
  ];

  meta = with lib; {
    description = "Language Server Protocol server for Jsonnet";
    mainProgram = "jsonnet-language-server";
    homepage = "https://github.com/grafana/jsonnet-language-server";
    changelog = "https://github.com/grafana/jsonnet-language-server/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ hardselius ];
  };
}
