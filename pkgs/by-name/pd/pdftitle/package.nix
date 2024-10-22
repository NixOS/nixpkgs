{
  lib,
  fetchFromGitHub,
  python3Packages,
  pdfminer
}:

python3Packages.buildPythonApplication rec {
  pname = "pdftitle";
  version = "0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metebalci";
    repo = "pdftitle";
    rev = "v${version}";
    hash = "sha256-7tIvvRlaKRC3/eRUS8F3d3qiJnCU0Z14Pj9E4v0X4+o=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pdfminer
  ];

  pythonImportsCheck = [ "pdftitle" ];

  meta = {
    description = "Utility to extract the title from a PDF file";
    homepage = "https://github.com/metebalci/pdftitle";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "pdftitle";
  };
}
