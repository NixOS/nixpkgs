{
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
  ssm-session-manager-plugin,
}:

python3Packages.buildPythonApplication rec {
  pname = "aws-gate";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xen0l";
    repo = "aws-gate";
    tag = version;
    hash = "sha256-9w2jP4s1HXf1gYiXX05Dt2iXt0bR0U48yc8h9T5M+EQ=";
  };

  patches = [
    ./disable-bootstrap.patch
  ];

  postPatch = ''
    rm aws_gate/bootstrap.py tests/unit/test_bootstrap.py
  '';

  nativeBuildInputs = [
    installShellFiles
    python3Packages.setuptools
    python3Packages.wheel
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    python3Packages.boto3
    python3Packages.cryptography
    python3Packages.marshmallow
    python3Packages.packaging
    python3Packages.pyyaml
    python3Packages.requests
    python3Packages.unix-ar
    python3Packages.wrapt
    ssm-session-manager-plugin
  ];

  postInstall = ''
    installShellCompletion --bash completions/bash/aws-gate
    installShellCompletion --zsh completions/zsh/_aws-gate
  '';

  checkPhase = ''
    $out/bin/aws-gate --version
  '';

  meta = with lib; {
    description = "Better AWS SSM Session manager CLI client";
    homepage = "https://github.com/xen0l/aws-gate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tirimia ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "aws-gate";
  };
}
