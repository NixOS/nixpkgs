{
  lib,
  buildPythonPackage,
  click,
  defusedxml,
  fetchFromGitHub,
  httpx,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "sfrbox-api";
  version = "0.0.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "sfrbox-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ec3UOserFijBK6goyM6AMOekfLgjBq8l/9sMKYnj240=";
  };

  pythonRelaxDeps = [
    "defusedxml"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    defusedxml
    mashumaro
    httpx
  ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "sfrbox_api" ];

  meta = with lib; {
    description = "Module for the SFR Box API";
    homepage = "https://github.com/hacf-fr/sfrbox-api";
    changelog = "https://github.com/hacf-fr/sfrbox-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sfrbox-api";
  };
}
