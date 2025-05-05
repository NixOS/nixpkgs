{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "legacy-cgi";
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = "legacy-cgi";
    tag = "v${version}";
    hash = "sha256-l2BuSlxAA31VlJ/Fhs4cGbidbXEt/zEH3BiWsuh29GM=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [
    "cgi"
    "cgitb"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/jackrosenthal/legacy-cgi/releases/tag/${src.tag}";
    description = "Fork of the standard library cgi and cgitb modules, being deprecated in PEP-594";
    homepage = "https://github.com/jackrosenthal/legacy-cgi";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
