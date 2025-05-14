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
  version = "3.23.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-elastic-beanstalk-cli";
    tag = version;
    hash = "sha256-Jaj90NRCwaxRQQlB4s4Us+liYiNohpwRsHuvKM5WmbU=";
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

    # AssertionError: Expected 'echo' to be called once. Called 2 times
    "test_multiple_modules__one_or_more_of_the_specified_modules_lacks_an_env_yaml"

    # fails on hydra only on aarch64-linux
    # ebcli.objects.exceptions.CredentialsError: Operation Denied. You appear to have no credentials
    "test_aws_eb_profile_environment_variable_found__profile_exists_in_credentials_file"
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
