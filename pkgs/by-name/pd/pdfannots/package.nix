{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pdfannots";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "0xabu";
    repo = "pdfannots";
    rev = "v${version}";
    hash = "sha256-C0Ss6kZvPx0hHnpBKquEolxeuTfjshhSBSIDXcCKtM8=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  propagatedBuildInputs = [
    python3.pkgs.pdfminer-six
  ];

  pythonImportsCheck = [
    "pdfannots"
  ];

<<<<<<< HEAD
  meta = {
    description = "Extracts and formats text annotations from a PDF file";
    homepage = "https://github.com/0xabu/pdfannots";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Extracts and formats text annotations from a PDF file";
    homepage = "https://github.com/0xabu/pdfannots";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "pdfannots";
  };
}
