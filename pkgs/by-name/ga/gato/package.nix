{ lib
, python3
, git
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gato";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "gato";
    rev = "refs/tags/${version}";
    hash = "sha256-vXQFgP0KDWo1VWe7tMGCB2yEYlr/1KMXsiNupBVLBqc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=gato" ""
  '';

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
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gato"
  ];

  meta = with lib; {
    description = "GitHub Self-Hosted Runner Enumeration and Attack Tool";
    homepage = "https://github.com/praetorian-inc/gato";
    changelog = "https://github.com/praetorian-inc/gato/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gato";
  };
}
