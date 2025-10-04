{
  lib,
  python3Packages,
  fetchurl,
}:

python3Packages.buildPythonApplication rec {
  pname = "pybritive";
  version = "2.2.3";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/britive/python-cli/releases/download/v${version}/pybritive-${version}.tar.gz";
    hash = "sha256-yKV5l3g1flGFobMExXJe1FKFmGJnDadqmgqf0OfZMqQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    britive
    click
    colored
    cryptography
    jmespath
    merge-args
    pyjwt
    python-dateutil
    pyyaml
    requests
    tabulate
    toml
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # CLI tests may require authentication
  doCheck = false;

  pythonImportsCheck = [ "pybritive" ];

  meta = {
    description = "A pure Python CLI for Britive";
    homepage = "https://github.com/britive/python-cli";
    changelog = "https://github.com/britive/python-cli/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matrixman ];
    mainProgram = "pybritive";
  };
}
