{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ocinferno";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetSPI";
    repo = "OCInferno";
    tag = finalAttrs.version;
    hash = "sha256-6CpyJxCiwM9bTX7VpsRdYXfJTIw7s24Aj0nWPbIcCo0=";
  };

  pythonRelaxDeps = [ "oci" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    kubernetes
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
    changelog = "https://github.com/NetSPI/OCInferno/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ocinferno";
  };
})
