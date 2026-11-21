{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "lil-pwny";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PaperMtn";
    repo = "lil-pwny";
    tag = finalAttrs.version;
    hash = "sha256-6FV2GwoksH8vhOEV4qnjHDZmr8QqBK934DFv3FwAKKc=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    charset-normalizer
    colorama
    pycryptodome
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "lil_pwny"
  ];

  meta = {
    description = "Offline auditing of Active Directory passwords";
    homepage = "https://github.com/PaperMtn/lil-pwny";
    changelog = "https://github.com/PaperMtn/lil-pwny/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lil-pwny";
  };
})
