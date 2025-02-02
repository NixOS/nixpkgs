{
  lib,
  python3,
  fetchPypi,
}:
let
  localPython = python3.override {
    self = localPython;
    packageOverrides = self: super: {
      # Can be removed once this is merged
      # https://gitlab.com/pdftools/pdfposter/-/merge_requests/7
      pypdf2 = super.pypdf2.overridePythonAttrs (oldAttrs: rec {
        version = "2.11.1";
        format = "setuptools";
        pyproject = null;
        src = fetchPypi {
          pname = "PyPDF2";
          inherit version;
          hash = "sha256-PHut1RLCFxHrF4nC6tv5YnkonA+URS7lSoZHO/vv1zI=";
        };
      });
    };
  };
in
with localPython.pkgs;
buildPythonApplication rec {
  pname = "pdfposter";
  version = "0.8.1";
  format = "setuptools";

  propagatedBuildInputs = [ pypdf2 ];

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
