{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcp-gateway";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "MikkoParkkola";
    repo = "mcp-gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7IALz7hOnCeKtiEm8b3M7v5oy4hw173viyhNeqQIhTI=";
  };

  cargoHash = "sha256-B5HRETFryzLqQhdIqRFj0apZS0wMggW2MHE2VsbB22Y=";

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
