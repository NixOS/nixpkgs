{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  braceexpand,
  inform,
}:

buildPythonPackage rec {
  pname = "shlib";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "shlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-f2jJgpjybutCpYnIT+RihtoA1YlXdhTs+MvV8bViSMQ=";
  };

  postPatch = ''
    patchShebangs .
  '';

  build-system = [ flit-core ];

  dependencies = [
    braceexpand
    inform
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shlib" ];

  meta = with lib; {
    description = "shell library";
    homepage = "https://github.com/KenKundert/shlib";
    changelog = "https://github.com/KenKundert/shlib/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
