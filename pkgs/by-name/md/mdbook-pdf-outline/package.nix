{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "mdbook-pdf-outline";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "mdbook_pdf_outline";
    hash = "sha256-GPTDlgYpfPtcq+rJCjxgexfViYiqHoVZ8iQkyWXNogw=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = [
    python3Packages.lxml
    python3Packages.pypdf
  ];

  meta = with lib; {
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];

  };
}
