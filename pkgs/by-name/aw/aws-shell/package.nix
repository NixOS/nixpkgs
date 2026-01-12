{
  python3Packages,
  lib,
  fetchFromGitHub,
  fetchPypi,
  awscli,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "aws-shell";
  version = "0.2.2";
  format = "setuptools";

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
      src = fetchPypi {
        pname = "prompt_toolkit";
        version = "1.0.18";
        hash = "sha256-3U/KAsgGlJetkxotCZFMaw0bUBUc6Ha8Fb3kx0cJASY=";
      };
      postPatch = null;
      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        wcwidth
        six
      ];
    }))
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    homepage = "https://github.com/awslabs/aws-shell";
    description = "Integrated shell for working with the AWS CLI";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "aws-shell";
  };
}
