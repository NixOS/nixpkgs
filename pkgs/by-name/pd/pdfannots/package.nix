{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pdfannots";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "0xabu";
    repo = "pdfannots";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Extracts and formats text annotations from a PDF file";
    homepage = "https://github.com/0xabu/pdfannots";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pdfannots";
  };
})
