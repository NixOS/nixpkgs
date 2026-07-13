{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcp-gateway";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "MikkoParkkola";
    repo = "mcp-gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R+k9NpbYcqu56cALHCU15lp0UCc3aJQGdk6ZJgs02D8=";
  };

  cargoHash = "sha256-quIQXrJ/ANOyh76Q3ZErUamLDfJpqPMYSZe9wUyS0Pg=";

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
