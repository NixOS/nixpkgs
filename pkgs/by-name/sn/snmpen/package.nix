{
  lib,
  fetchFromGitHub,
  python3,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "snmpen";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = "snmpen";
    tag = finalAttrs.version;
    hash = "sha256-PH1kUnDOiiE7ouEkhd1+TuIBziB2uxCVnmiEkCgQma0=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    humanize
    pysnmp
    rich
  ];

  nativeBuildInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-asyncio
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [ "snmpen" ];

  doInstallCheck = true;

  meta = {
    description = "SNMP Enumeration tool";
    homepage = "https://github.com/fabaff/snmpen";
    changelog = "https://github.com/fabaff/snmpen/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "snmpen";
  };
})
