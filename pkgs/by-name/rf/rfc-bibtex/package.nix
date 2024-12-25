{
  lib,
  fetchFromGitHub,
  python3,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "rfc-bibtex";
  version = "0.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iluxonchik";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bPCNQqiG50vWVFA6J2kyxftwsXunHTNBdSkoIRYkb0s=";
  };

  nativeCheckInputs = [
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
