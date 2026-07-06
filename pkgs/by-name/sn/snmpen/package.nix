{
  lib,
  fetchFromGitHub,
  python3,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "snmpen";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = "snmpen";
    tag = finalAttrs.version;
    hash = "sha256-XJP+f5Ahizxgk80B0896sbE6JeNB0Bm7aafwJsFaHYY=";
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
    homepage = "https://github.com/affolter-engineering/snmpen";
    changelog = "https://github.com/affolter-engineering/snmpen/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "snmpen";
  };
})
