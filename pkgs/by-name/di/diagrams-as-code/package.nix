{
  lib,
  python3Packages,
  fetchFromGitHub,
  runCommand,
  diagrams-as-code,
}:

python3Packages.buildPythonPackage rec {
  pname = "diagrams-as-code";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmytrostriletskyi";
    repo = "diagrams-as-code";
    rev = "refs/tags/v${version}";
    hash = "sha256-cd602eQvNCUQuCdn/RpcfURcDHjXLZ0gAG+SObB++Q0=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    diagrams
    pydantic
    pyyaml
  ];

  pythonRelaxDeps = [
    "diagrams"
    "pydantic"
  ];

  pythonImportsCheck = [ "diagrams_as_code" ];

  doCheck = false; # no tests

  passthru.tests = {
    simple = runCommand "${pname}-test" { } ''
      # giving full path to diagrams-as-code causes
      # a bad path concatenation
      cp ${diagrams-as-code.src}/examples/all-fields.yaml .

      ${lib.getExe diagrams-as-code} all-fields.yaml

      cp web-services-architecture-aws.jpg $out
    '';
  };

  meta = {
    description = "Declarative configurations using YAML for drawing cloud system architectures";
    homepage = "https://github.com/dmytrostriletskyi/diagrams-as-code";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "diagrams-as-code";
  };
}
