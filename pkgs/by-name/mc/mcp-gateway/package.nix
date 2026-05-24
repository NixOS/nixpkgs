{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcp-gateway";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "MikkoParkkola";
    repo = "mcp-gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B8aAsAy3pyRGOb2opxllwPgv1uNYilTud4Lm0cxMW20=";
  };

  cargoHash = "sha256-3Dg3yiOCldP+D+k1oORMCo0Xi9eGApEUmOZZc8poH2Y=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  # Most of the tests are failing.
  doCheck = false;

  meta = {
    description = "Universal MCP Gateway - Single-port multiplexing with Meta-MCP for ~95% context token savings";
    homepage = "https://github.com/MikkoParkkola/mcp-gateway";
    changelog = "https://github.com/MikkoParkkola/mcp-gateway/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcp-gateway";
  };
})
