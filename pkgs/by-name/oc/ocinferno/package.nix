{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ocinferno";
  version = "0.6.2-unstable-2026-08-03";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NetSPI";
    repo = "OCInferno";
    # https://github.com/NetSPI/OCInferno/issues/30
    rev = "3cb32c783ad3a39ffc378005db8f0b30bb967be6";
    hash = "sha256-dOemOE3+FOMQxQ7yseBbPjSLCoHQxl/3t7Y6mFfC3yI=";
  };

  pythonRelaxDeps = [ "oci" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    oci
    oci-lexer-parser
    pandas
    prettytable
    requests
    xlsxwriter
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "ocinferno" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for enumeration/download/graphical analysis of OCI content";
    homepage = "https://github.com/NetSPI/OCInferno";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ocinferno";
  };
})
