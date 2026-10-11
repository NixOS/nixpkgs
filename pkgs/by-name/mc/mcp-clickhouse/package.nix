{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-clickhouse";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ClickHouse";
    repo = "mcp-clickhouse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IwtH6YWzMpLVKUt+62nwvOt91OklGlmi08VFIgi03X0=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    cachetools
    clickhouse-connect
    fastmcp
    pydantic
    python-dotenv
    simplejson
    starlette
    truststore
    uvicorn
  ];

  pythonImportsCheck = [ "mcp_clickhouse" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests.clickhouse) mcp;
    };
  };

  meta = {
    description = "MCP server for ClickHouse";
    homepage = "https://github.com/ClickHouse/mcp-clickhouse";
    changelog = "https://github.com/ClickHouse/mcp-clickhouse/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jpds
      thevar1able
    ];
    mainProgram = "mcp-clickhouse";
    platforms = lib.platforms.all;
  };
})
