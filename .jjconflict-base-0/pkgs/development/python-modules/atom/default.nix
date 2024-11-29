{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  cppy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "atom";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = "atom";
    rev = "refs/tags/${version}";
    hash = "sha256-3Xk4CM8Cnkc0lIdjJUYs/6UTqqpPALrUa3DpKD40og8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ cppy ];

  preCheck = ''
    rm -rf atom
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "atom.api" ];

  meta = with lib; {
    description = "Memory efficient Python objects";
    homepage = "https://github.com/nucleic/atom";
    changelog = "https://github.com/nucleic/atom/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
