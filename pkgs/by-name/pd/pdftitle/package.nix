{
  lib,
  fetchFromGitHub,
  python3Packages,
  pdfminer,
}:

python3Packages.buildPythonApplication rec {
  pname = "pdftitle";
  version = "0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metebalci";
    repo = "pdftitle";
    rev = "v${version}";
    hash = "sha256-IEctzvNHlGYUMl3jfTVNinmfMviVQ9q15OZtRN1mhZc=";
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
