{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.8.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a4VdbZY8pYxrXIaUHJpnLuTB928tJn4UCdnt+m8UBug=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyopenssl
    requests
    tldextract
  ];

  meta = with lib; {
    homepage = "https://github.com/komuw/sewer";
    description = "ACME client";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
  };
}
