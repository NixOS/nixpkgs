{
  lib,
  python3,
  git,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gato";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "gato";
    tag = version;
    hash = "sha256-vXQFgP0KDWo1VWe7tMGCB2yEYlr/1KMXsiNupBVLBqc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    cryptography
    packaging
    pyyaml
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    git
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gato"
  ];

  meta = {
    description = "GitHub Self-Hosted Runner Enumeration and Attack Tool";
    homepage = "https://github.com/praetorian-inc/gato";
    changelog = "https://github.com/praetorian-inc/gato/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gato";
  };
}
