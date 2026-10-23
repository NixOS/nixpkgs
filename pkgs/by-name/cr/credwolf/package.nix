{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "credwolf";
  version = "1.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "CredWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R6yqaWX7RB+jElFfWec5dpBpQvlvQULEpgiiVTUzPWU=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    impacket
    pyasn1
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "credwolf" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to validate AD credentials over NTLM and Kerberos";
    homepage = "https://github.com/StrongWind1/CredWolf";
    changelog = "https://github.com/StrongWind1/CredWolf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "credwolf";
  };
})
