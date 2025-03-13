{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "beanhub-import";
  version = "1.1.1";
  pyproject = true;

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-import";
    tag = version;
    hash = "sha256-emBeDx1f5TqM5KJvzgHHDU7jF4OD3hdjaFqkjHkTh70=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    beancount-black
    beancount-parser
    beanhub-extract
    jinja2
    pydantic
    pytz
    pyyaml
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beanhub_import" ];

  meta = {
    description = "Declarative idempotent rule-based Beancount transaction import engine in Python";
    homepage = "https://github.com/LaunchPlatform/beanhub-import/";
    changelog = "https://github.com/LaunchPlatform/beanhub-import/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
