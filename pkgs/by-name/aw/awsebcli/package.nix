{
  lib,
  python3,
  fetchFromGitHub,
  git,
}:

let
  changeVersion =
    overrideFunc: version: hash:
    overrideFunc (oldAttrs: rec {
      inherit version;
      src = oldAttrs.src.override {
        inherit version hash;
      };
    });

  localPython = python3.override {
    self = localPython;
    packageOverrides = self: super: {
      cement =
        changeVersion super.cement.overridePythonAttrs "2.10.14"
          "sha256-NC4n21SmYW3RiS7QuzWXoifO4z3C2FVgQm3xf8qQcFg=";
    };
  };

in

localPython.pkgs.buildPythonApplication rec {
  pname = "awsebcli";
  version = "3.21";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-elastic-beanstalk-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-VU8bXvS4m4eIamjlgGmHE2qwDXWAXvWTa0QHomXR5ZE=";
  };

  postPatch = ''
    # https://github.com/aws/aws-elastic-beanstalk-cli/pull/469
    substituteInPlace setup.py --replace-fail "scripts=['bin/eb']," ""
  '';

  propagatedBuildInputs = with localPython.pkgs; [
    blessed
    botocore
    cement
    colorama
    pathspec
    pyyaml
    future
    requests
    semantic-version
    setuptools
    tabulate
    termcolor
    websocket-client
  ];

  pythonRelaxDeps = [
    "botocore"
    "colorama"
    "pathspec"
    "PyYAML"
    "six"
    "termcolor"
  ];

  nativeCheckInputs = with localPython.pkgs; [
    pytestCheckHook
    pytest-socket
    mock
    git
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  disabledTests = [
    # Needs docker installed to run.
    "test_local_run"
    "test_local_run__with_arguments"

    # Needs access to the user's ~/.ssh directory.
    "test_generate_and_upload_keypair__exit_code_0"
    "test_generate_and_upload_keypair__exit_code_1"
    "test_generate_and_upload_keypair__exit_code_is_other_than_1_and_0"
    "test_generate_and_upload_keypair__ssh_keygen_not_present"
  ];

  meta = with lib; {
    homepage = "https://aws.amazon.com/elasticbeanstalk/";
    description = "Command line interface for Elastic Beanstalk";
    changelog = "https://github.com/aws/aws-elastic-beanstalk-cli/blob/${version}/CHANGES.rst";
    maintainers = with maintainers; [ kirillrdy ];
    license = licenses.asl20;
    mainProgram = "eb";
  };
}
