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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hollowman6 ];
=======
  meta = with lib; {
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  };
}
