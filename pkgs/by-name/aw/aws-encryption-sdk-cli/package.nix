{
  lib,
  aws-encryption-sdk-cli,
  fetchPypi,
  nix-update-script,
  python3,
  testers,
}:

let
  localPython = python3.override {
    self = localPython;
    packageOverrides = final: prev: {
      urllib3 = prev.urllib3.overridePythonAttrs (prev: rec {
        version = "1.26.18";
        build-system = with final; [
          setuptools
        ];
        postPatch = null;
        src = prev.src.override {
          inherit version;
          hash = "sha256-+OzBu6VmdBNFfFKauVW/jGe0XbeZ0VkGYmFxnjKFgKA=";
        };
      });
    };
  };
in

localPython.pkgs.buildPythonApplication rec {
  pname = "aws-encryption-sdk-cli";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gORrscY+Bgmz2FrKdSBd56jP0yuEklytMeA3wr8tTZU=";
  };

  pythonRelaxDeps = [ "aws-encryption-sdk" ];

  build-system = with localPython.pkgs; [
    setuptools
  ];

  dependencies = with localPython.pkgs; [
    attrs
    aws-encryption-sdk
    base64io
    setuptools # for pkg_resources
    urllib3
  ];

  doCheck = true;

  nativeCheckInputs = with localPython.pkgs; [
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
    changelog = "https://github.com/aws/aws-encryption-sdk-cli/blob/v${version}/CHANGELOG.rst";
    description = "CLI wrapper around aws-encryption-sdk-python";
    license = lib.licenses.asl20;
    mainProgram = "aws-encryption-cli";
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
