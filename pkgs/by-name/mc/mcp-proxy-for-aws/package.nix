{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  pname = "mcp-proxy-for-aws";
  version = "1.6.4";
in

python3Packages.buildPythonApplication (finalAttrs: {
  inherit pname version;
  __structuredAttrs = true;

  pyproject = true;
  build-system = [ python3Packages.hatchling ];
  disabled = python3Packages.pythonOlder "3.10";
  pythonImportsCheck = [ "mcp_proxy_for_aws" ];

  src = fetchFromGitHub {
    owner = "aws";
    repo = "mcp-proxy-for-aws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cVkDC5cjXNSoXA1JlgKtGdfQMamoDpPR80b0JiqeiNw=";
  };

  dependencies = with python3Packages; [
    awscrt
    fastmcp
    boto3
    botocore
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [ "tests/integ" ];
  disabledTests = [ "test_parse_args_missing_endpoint" ];

  meta = {
    description = "MCP Proxy for AWS";
    homepage = "https://github.com/aws/mcp-proxy-for-aws";
    changelog = "https://github.com/aws/mcp-proxy-for-aws/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "mcp-proxy-for-aws";
    maintainers = with lib.maintainers; [ loganphinney ];
  };
})
