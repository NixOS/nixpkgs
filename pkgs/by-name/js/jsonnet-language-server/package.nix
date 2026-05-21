{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jsonnet-language-server";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hMs26mCPghCTCs8Ixf/wcHbUUpMPLicTK6HuUFMzkws=";
  };

  vendorHash = "sha256-Kb/ejDUdS+YZnVpzxscOnVVpQcdVicDdJvfUTc6Kg0o=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${finalAttrs.version}'"
  ];

  meta = {
    description = "Language Server Protocol server for Jsonnet";
    mainProgram = "jsonnet-language-server";
    homepage = "https://github.com/grafana/jsonnet-language-server";
    changelog = "https://github.com/grafana/jsonnet-language-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ hardselius ];
  };
})
