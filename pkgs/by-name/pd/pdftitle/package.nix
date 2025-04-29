{
  lib,
  fetchFromGitHub,
  python3Packages,
  pdfminer,
}:

python3Packages.buildPythonApplication rec {
  pname = "pdftitle";
  version = "0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metebalci";
    repo = "pdftitle";
    tag = "v${version}";
    hash = "sha256-rGGO4Cy+DZRU3ywb6Jq55JiM8ALgs/9wQmeXcSbPpG0=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ pdfminer ];

  pythonImportsCheck = [ "pdftitle" ];

  meta = {
    description = "Utility to extract the title from a PDF file";
    homepage = "https://github.com/metebalci/pdftitle";
    changelog = "https://github.com/metebalci/pdftitle/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "pdftitle";
  };
}
