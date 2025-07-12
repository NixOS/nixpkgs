{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rfc-bibtex";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iluxonchik";
    repo = "rfc-bibtex";
    tag = version;
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

  meta = with lib; {
    homepage = "https://github.com/iluxonchik/rfc-bibtex/";
    description = "Generate Bibtex entries for IETF RFCs and Internet-Drafts";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
    mainProgram = "rfcbibtex";
  };
}
