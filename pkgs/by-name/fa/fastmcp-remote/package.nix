{
  lib,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fastmcp-remote";
  inherit (python3Packages.fastmcp) version src;

  sourceRoot = "${finalAttrs.src.name}/fastmcp_remote";
  pyproject = true;

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = lib.flatten (
    with python3Packages;
    [
      fastmcp-slim
      fastmcp-slim.optional-dependencies.client
      fastmcp-slim.optional-dependencies.server
    ]
  );

  nativeCheckInputs = with python3Packages; [
    inline-snapshot
    opentelemetry-sdk
    pytest-asyncio
    pytest-env
    pytestCheckHook
    pytest-timeout
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    "-pno:cacheprovider"
    "../tests/cli/test_fastmcp_remote.py"
  ];

  preCheck = ''
    export FASTMCP_REMOTE_CONFIG_DIR="$TMPDIR/fastmcp-remote-config"
    mkdir -p "$FASTMCP_REMOTE_CONFIG_DIR"
  '';

  pythonImportsCheck = [ "fastmcp_remote" ];

  postInstallCheck = ''
    $out/bin/fastmcp-remote --help >/dev/null
  '';

  meta = {
    description = "Python stdio bridge for remote MCP servers, powered by FastMCP";
    homepage = "https://gofastmcp.com";
    changelog = "https://github.com/PrefectHQ/fastmcp/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tyceherrman ];
    mainProgram = "fastmcp-remote";
  };
})
