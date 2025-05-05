{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  hypothesis,
  pytestCheckHook,
  ochre,
}:

buildPythonPackage rec {
  pname = "stransi";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "getcuia";
    repo = "stransi";
    rev = "v${version}";
    hash = "sha256-PDMel6emra5bzX+FwHvUVpFu2YkRKy31UwkCL4sGJ14=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  propagatedBuildInputs = [ ochre ];

  pythonImportsCheck = [ "stransi" ];

  meta = with lib; {
    description = "Lightweight Python parser library for ANSI escape code sequences";
    homepage = "https://github.com/getcuia/stransi";
    changelog = "https://github.com/getcuia/stransi/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
