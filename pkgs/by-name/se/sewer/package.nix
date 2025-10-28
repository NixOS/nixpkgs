{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.8.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a4VdbZY8pYxrXIaUHJpnLuTB928tJn4UCdnt+m8UBug=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyopenssl
    requests
    tldextract
  ];

  pythonImportsCheck = [ "sewer" ];

  meta = with lib; {
    homepage = "https://github.com/komuw/sewer";
    description = "ACME client";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
  };
}
