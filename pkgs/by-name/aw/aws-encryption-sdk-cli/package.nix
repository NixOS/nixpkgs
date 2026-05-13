{
  lib,
  aws-encryption-sdk-cli,
  fetchPypi,
  nix-update-script,
  python3Packages,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aws-encryption-sdk-cli";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "aws_encryption_sdk_cli";
    hash = "sha256-FfLgR7gocZ0cLV7bxqvKNI+Fs7kQF0XhR3zf6tHXwOE=";
  };

  pythonRelaxDeps = [ "aws-encryption-sdk" ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    attrs
    aws-encryption-sdk
    base64io
    setuptools # for pkg_resources
    urllib3
  ];

  doCheck = true;

  nativeCheckInputs = with python3Packages; [
    mock
    pytest-mock
    pytest7CheckHook
  ];

  disabledTestPaths = [
    # requires networking
    "test/integration"
  ];

  # Upstream did not adapt to pytest 8 yet.
  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn8Warning"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = aws-encryption-sdk-cli;
      command = "aws-encryption-cli --version";
    };
  };

  meta = {
    homepage = "https://aws-encryption-sdk-cli.readthedocs.io/";
    changelog = "https://github.com/aws/aws-encryption-sdk-cli/blob/v${finalAttrs.version}/CHANGELOG.rst";
    description = "CLI wrapper around aws-encryption-sdk-python";
    license = lib.licenses.asl20;
    mainProgram = "aws-encryption-cli";
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
