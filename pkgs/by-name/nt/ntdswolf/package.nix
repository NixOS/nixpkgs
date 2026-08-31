{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ntdswolf";
  version = "0.6.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "StrongWind1";
    repo = "NTDSWolf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dPL8qnByz1ALyQLPAzQp0yaDLKYuqXVAlrdZ7lnrRNU=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    dissect-database
    dissect-regf
    dpapi-ng
    pycryptodome
    rich
    typer
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "ntdswolf" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offline NTDS.dit parser and credential extractor for Active Directory forensics";
    homepage = "https://github.com/StrongWind1/NTDSWolf";
    changelog = "https://github.com/StrongWind1/NTDSWolf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ntdswolf";
  };
})
