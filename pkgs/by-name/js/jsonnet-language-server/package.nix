{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    tag = "v${version}";
    hash = "sha256-xvN2fq94sD6E/HwZrLSr3TIO5eeuyhvj4UmJCIUFSH0=";
  };

  vendorHash = "sha256-Kb/ejDUdS+YZnVpzxscOnVVpQcdVicDdJvfUTc6Kg0o=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${version}'"
  ];

  meta = {
    description = "Language Server Protocol server for Jsonnet";
    mainProgram = "jsonnet-language-server";
    homepage = "https://github.com/grafana/jsonnet-language-server";
    changelog = "https://github.com/grafana/jsonnet-language-server/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ hardselius ];
  };
}
