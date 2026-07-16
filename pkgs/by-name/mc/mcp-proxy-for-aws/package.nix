{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  pname = "mcp-proxy-for-aws";
  version = "1.6.3";
in

python3Packages.buildPythonPackage {
  __structuredAttrs = true;
  inherit pname version;

  pyproject = true;
  disabled = python3Packages.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "mcp-proxy-for-aws";
    rev = "v${version}";
    hash = "sha256-l8SUe6yjO3D0vchmzrzs6HxJQbO62YICU3BkEr4NUSk=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    fastmcp
    boto3
    botocore
  ];

  pythonImportsCheck = [
    "mcp_proxy_for_aws"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [
    "tests/integ"
  ];

  meta = {
    description = "MCP Proxy for AWS";
    homepage = "https://github.com/aws/mcp-proxy-for-aws";
    license = lib.licenses.asl20;
    mainProgram = "mcp-proxy-for-aws";
    maintainers = with lib.maintainers; [ loganphinney ];
  };
}
