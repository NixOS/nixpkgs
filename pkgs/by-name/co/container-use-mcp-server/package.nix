{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "container-use-mcp-server";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "container-use";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7AejiFWRzwxDc0DCgDTnmPpXBtZ1AAXrbiY3fCXjJj0=";
  };

  vendorHash = "sha256-LvLSVP0Qox04bDoxfNtR5qls9B8AWii4icY+Ac1q9N4=";

  subPackages = [ "cmd/cu" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/cu";

  versionCheckProgramArg = "version";

  meta = {
    description = "Development environments for coding agents";
    longDescription = ''
      Container Use is an MCP (Model Context Protocol) server that provides
      isolated containerized environments for coding agents. It enables multiple
      agents to work safely and independently with real-time visibility into
      agent actions and direct terminal intervention capabilities.
    '';
    homepage = "https://github.com/dagger/container-use";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connerohnesorge ];
    mainProgram = "cu";
  };
})
