{
  lib,
  fetchFromGitHub,
  python3Packages,
  pdfminer
}:

python3Packages.buildPythonApplication rec {
  pname = "pdftitle";
  version = "0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metebalci";
    repo = "pdftitle";
    rev = "v${version}";
    hash = "sha256-kj1pJpyWRgEaAADF6YqzdD8QnJ6iu0eXFMR4NGM4/+Y=";
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
