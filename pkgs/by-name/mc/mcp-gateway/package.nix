{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcp-gateway";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "MikkoParkkola";
    repo = "mcp-gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-shn2cv463SnegamsMu6NmfylnNaFzGJLoL2H7QhETY8=";
  };

  cargoHash = "sha256-XuOYuYapb2l7RHQIgLDfcDPtSdMDpEgti8Ud5ssuGC8=";

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
