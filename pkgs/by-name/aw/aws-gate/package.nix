{ lib
, fetchFromGitHub
, installShellFiles
, python3Packages
, ssm-session-manager-plugin
}:

python3Packages.buildPythonApplication rec {
  pname = "aws-gate";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xen0l";
    repo = pname;
    rev = version;
    hash = "sha256-9w2jP4s1HXf1gYiXX05Dt2iXt0bR0U48yc8h9T5M+EQ=";
  };

  patches = [
    ./disable-bootstrap.patch
  ];

  postPatch = ''
    rm aws_gate/bootstrap.py tests/unit/test_bootstrap.py
  '';

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    installShellFiles
  ];

  propagatedBuildInputs = [ ssm-session-manager-plugin ] ++ builtins.attrValues {
    inherit (python3Packages) marshmallow boto3 pyyaml wrapt cryptography;
  };

  postInstall = ''
    installShellCompletion --bash completions/bash/aws-gate
    installShellCompletion --zsh completions/zsh/_aws-gate
  '';

  checkPhase = ''
    $out/bin/${pname} --version
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
