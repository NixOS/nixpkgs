{
  lib,
  fetchFromGitHub,
  python3Packages,
  uv,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;
  pname = "mcp-proxy-for-aws";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "mcp-proxy-for-aws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nYTa/a5UI9p1ZAqfTDJ8r909YNsIbWevPMhVn9ysyNg=";
  };

  pyproject = true;
  disabled = python3Packages.pythonOlder "3.10" || python3Packages.pythonAtLeast "3.15";
  build-system = [ python3Packages.hatchling ];
  nativeBuildInputs = [ uv ];

  dependencies = with python3Packages; [
    awscrt
    boto3
    botocore
    fastmcp
    httpx
  ];

  pythonImportsCheck = [ "mcp_proxy_for_aws" ];

  preBuild = ''
    export UV_CACHE_DIR="$TMPDIR/uv-cache"
    export UV_PYTHON="${python3Packages.python.interpreter}"
  '';

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
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
