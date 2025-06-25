{
  lib,
  fetchFromGitHub,
  python3Packages,
  openai,
  pdfminer,

  withOpenai ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "pdftitle";
  version = "0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metebalci";
    repo = "pdftitle";
    tag = "v${version}";
    hash = "sha256-05SaAXYJ7l0ZldYufj0x9mYRwwGT7vlmq9a+ZF4pYiA=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      pdfminer
      python-dotenv
    ]
    ++ lib.optional withOpenai openai;

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
