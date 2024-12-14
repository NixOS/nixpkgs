{
  python3Packages,
  lib,
  fetchFromGitHub,
  awscli,
}:

python3Packages.buildPythonApplication rec {
  pname = "aws-shell";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-shell";
    rev = "refs/tags/${version}";
    hash = "sha256-m96XaaFDFQaD2YPjw8D1sGJ5lex4Is4LQ5RhGzVPvH4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    botocore
    pygments
    mock
    configobj
    awscli
    (prompt-toolkit.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "prompt-toolkit";
        repo = "python-prompt-toolkit";
        rev = "refs/tags/1.0.18"; # Need >=1.0.0,<1.1.0
        hash = "sha256-mt/fIubkpeVc7vhAaTk0pXZXI8JzB7n2MzXqgqK0wE4=";
      };
    }))
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    homepage = "https://github.com/awslabs/aws-shell";
    description = "Integrated shell for working with the AWS CLI";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "aws-shell";
  };
}
