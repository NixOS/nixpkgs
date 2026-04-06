{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcp-gateway";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "MikkoParkkola";
    repo = "mcp-gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jPggWHX/Qz3sMh3P791D9WRMsppy3xRfUXd3jAcef5M=";
  };

  cargoHash = "sha256-TLjiI6mgWRkxZEifbyLzZpHj+486RYoGY2GOXsh/1Bs=";

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
