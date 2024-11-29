{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vx6XKtMzROkyBpZPtM2QjZ3e+fzQwB+pPg1zRnU5Q2M=";
  };

  # Test suite not included in tarball yet
  # See https://github.com/ebook-utils/css-parser/pull/2
  doCheck = false;

  pythonImportsCheck = [ "css_parser" ];

  meta = with lib; {
    description = "CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/ebook-utils/css-parser";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jethro ];
  };
}
