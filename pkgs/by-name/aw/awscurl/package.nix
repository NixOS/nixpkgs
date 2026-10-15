{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "awscurl";
  version = "0.44";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "okigan";
    repo = "awscurl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XMPvAQ7O42HCdVHABe9GENNLIKrYzrpCdfh7dcym2Y8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    awscrt
    boto3
    botocore
    configargparse
    configparser
    requests
    urllib3
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires internet
    "tests/integration_test.py"
    "tests/tls_test.py"
  ];

  meta = {
    description = "Curl like tool with AWS request signing";
    homepage = "https://github.com/okigan/awscurl";
    changelog = "https://github.com/okigan/awscurl/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
})
