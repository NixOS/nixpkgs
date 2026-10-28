{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "rfc-bibtex";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iluxonchik";
    repo = "rfc-bibtex";
    tag = finalAttrs.version;
    hash = "sha256-bPCNQqiG50vWVFA6J2kyxftwsXunHTNBdSkoIRYkb0s=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [
    "rfc_bibtex"
  ];

  meta = {
    homepage = "https://github.com/iluxonchik/rfc-bibtex/";
    description = "Generate Bibtex entries for IETF RFCs and Internet-Drafts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "rfcbibtex";
  };
})
