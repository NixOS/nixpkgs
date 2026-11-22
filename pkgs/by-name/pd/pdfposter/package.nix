{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "pdfposter";
  version = "0.9.1";
  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ pypdf ];

  src = fetchPypi {
    pname = "pdfposter";
    inherit version;
    hash = "sha256-Y5gUrHI470vsORETxkpf3WH5YXgdIeTZvSb3v/UgD24=";
  };

  pythonImportsCheck = [
    "pdfposter"
    "pdfposter.cmd"
  ];

  meta = {
    description = "Split large pages of a PDF into smaller ones for poster printing";
    mainProgram = "pdfposter";
    homepage = "https://pdfposter.readthedocs.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wamserma ];
  };
}
