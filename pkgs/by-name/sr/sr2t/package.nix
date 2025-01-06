{
  lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sr2t";
  version = "0.0.26";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "0bs1d1an";
    repo = "sr2t";
    rev = "refs/tags/${version}";
    hash = "sha256-BPsYnKBTxt5WUd2+WumMdVi8p6iryOWG2MjI97qbaCw=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    prettytable
    pyyaml
    setuptools
    xlsxwriter
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sr2t" ];

  meta = with lib; {
    description = "Tool to convert scanning reports to a tabular format";
    homepage = "https://gitlab.com/0bs1d1an/sr2t";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sr2t";
  };
}
