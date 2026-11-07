{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  # NOTE that this is not https://pypi.org/project/yakh/
  pname = "python-yakh";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petereon";
    repo = "yakh";
    rev = "v${version}";
    hash = "sha256-r+vDwiFnMJ+C4DhsbVhcKzVhAbFqDkRaaLcmuyN2XBY=";
  };

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [
    "yakh"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Yet Another Keypress Handler";
    homepage = "https://pypi.org/project/python-yakh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
