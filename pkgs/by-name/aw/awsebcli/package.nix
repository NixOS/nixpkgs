{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  git,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      cement = super.cement.overridePythonAttrs (old: rec {
        pname = "cement";
        version = "2.10.14";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-NC4n21SmYW3RiS7QuzWXoifO4z3C2FVgQm3xf8qQcFg=";
        };
        build-system = old.build-system or [ ] ++ (with python.pkgs; [ setuptools ]);
        doCheck = false;
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "awsebcli";
  version = "3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-elastic-beanstalk-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-VU8bXvS4m4eIamjlgGmHE2qwDXWAXvWTa0QHomXR5ZE=";
  };

  pythonRelaxDeps = [
    "botocore"
    "colorama"
    "pathspec"
    "PyYAML"
    "six"
    "termcolor"
    "urllib3"
  ];

  postPatch = ''
    # https://github.com/aws/aws-elastic-beanstalk-cli/pull/469
    substituteInPlace setup.py \
      --replace-fail "scripts=['bin/eb']," ""
  '';

  dependencies = with python.pkgs; [
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

  nativeCheckInputs = with python.pkgs; [
    git
    mock
    pytest-socket
    pytestCheckHook
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
    description = "Command line interface for Elastic Beanstalk";
    homepage = "https://aws.amazon.com/elasticbeanstalk/";
    changelog = "https://github.com/aws/aws-elastic-beanstalk-cli/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ kirillrdy ];
    mainProgram = "eb";
  };
}
