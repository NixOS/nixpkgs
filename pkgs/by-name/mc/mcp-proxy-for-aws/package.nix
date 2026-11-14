{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (final: prev: { mcp = final.mcp_1; });
in

pythonPackages.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;

  pname = "mcp-proxy-for-aws";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "mcp-proxy-for-aws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kB13sqkZQ7m5jZvkozABSXqXkDbChOT/MJc3UOHy9fk=";
  };

  pyproject = true;
  disabled = pythonPackages.pythonOlder "3.11" || pythonPackages.pythonAtLeast "3.15";
  build-system = [ pythonPackages.hatchling ];

  dependencies =
    with pythonPackages;
    [
      boto3
      botocore
      fastmcp
      httpx
    ]
    ++ botocore.optional-dependencies.crt;

  pythonImportsCheck = [ "mcp_proxy_for_aws" ];

  preBuild = ''
    export UV_CACHE_DIR="$TMPDIR/uv-cache"
  '';

  nativeCheckInputs = with pythonPackages; [
    pytest-asyncio
    pytestCheckHook
    uv
  ];

  disabledTestPaths = [
    "tests/integ"
    "packages/proxy/tests/test_packaging.py"
  ];

  meta = {
    description = "MCP Proxy for AWS";
    homepage = "https://github.com/aws/mcp-proxy-for-aws";
    changelog = "https://github.com/aws/mcp-proxy-for-aws/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "mcp-proxy-for-aws";
    maintainers = with lib.maintainers; [ loganphinney ];
  };
})
