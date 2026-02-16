{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ha-mcp";
  version = "6.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yAJbvfIH5ewRTip8whbOKxE479qAihESaiLFTnhpRkY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      cryptography
      fastmcp
      httpx
      jq
      pydantic
      python-dotenv
      truststore
      websockets
    ]
    ++ httpx.optional-dependencies.socks;

  # Tests require a running Home Assistant instance
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  pythonImportsCheck = [ "ha_mcp" ];

  meta = {
    description = "MCP server for controlling Home Assistant via natural language";
    homepage = "https://github.com/homeassistant-ai/ha-mcp";
    changelog = "https://github.com/homeassistant-ai/ha-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "ha-mcp";
  };
})
