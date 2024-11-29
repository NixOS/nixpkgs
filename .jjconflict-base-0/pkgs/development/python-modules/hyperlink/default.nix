{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  idna,
  typing ? null,
}:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "21.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sx50lkivsfjxx9zr4yh7l9gll2l9kvl0v0w8w4wk2x5v9bzjyj2";
  };

  propagatedBuildInputs = [ idna ] ++ lib.optionals isPy27 [ typing ];

  meta = with lib; {
    description = "Featureful, correct URL for Python";
    homepage = "https://github.com/python-hyper/hyperlink";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
