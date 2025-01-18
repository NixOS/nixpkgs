{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    tag = "v${version}";
    hash = "sha256-InU7iH7fP1k9+Vn8/WfNQnbIeQ6SGY17Z2vsRD63uzk=";
  };

  vendorHash = "sha256-xYB6MJoA9/tdnPTMdkBxI/sx1rDnS0qy+HCf72B1/cU=";

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
