{
  lib,
  python3Packages,
  fetchPypi,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "pdfposter";
  version = "0.8.1";
  pyproject = true;

  dependencies = with python3Packages; [
    (pypdf.overridePythonAttrs {
      version = "4.3.1";

      src = fetchFromGitHub {
        owner = "py-pdf";
        repo = "pypdf";
        rev = "refs/tags/${version}";
        # fetch sample files used in tests
        fetchSubmodules = true;
        hash = "sha256-wSF20I5WaxRoN0n0jxB5O3mAAIOxP/TclYBTRAUwYHo=";
      };
    })
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  patches = [
    # based on https://gitlab.com/pdftools/pdfposter/-/commit/066aeb918db7504f21ee9127b35603a06101a72a.patch
    ./port-to-python-library-pypdf-version-3.patch
  ];
  src = fetchPypi {
    pname = "pdftools.pdfposter";
    inherit version;
    hash = "sha256-yWFtHgVKAWs4dRlSk8t8cB2KBJeBOa0Frh3BLR9txS0=";
  };

  pythonImportsCheck = [
    "pdftools.pdfposter"
    "pdftools.pdfposter.cmd"
  ];

  meta = with lib; {
    description = "Split large pages of a PDF into smaller ones for poster printing";
    mainProgram = "pdfposter";
    homepage = "https://pdfposter.readthedocs.io";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wamserma ];
  };
}
