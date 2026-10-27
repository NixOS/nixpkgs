{
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
  ssm-session-manager-plugin,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aws-gate";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xen0l";
    repo = "aws-gate";
    tag = finalAttrs.version;
    hash = "sha256-9w2jP4s1HXf1gYiXX05Dt2iXt0bR0U48yc8h9T5M+EQ=";
  };

  patches = [
    ./disable-bootstrap.patch
    # default and missing parameters, which were replaced by dump_default and load_default
    # https://github.com/xen0l/aws-gate/pull/1770
    ./fix-compatibility-with-marshmallow-4.x.patch
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

  meta = {
    description = "Better AWS SSM Session manager CLI client";
    homepage = "https://github.com/xen0l/aws-gate";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tirimia ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "aws-gate";
  };
})
