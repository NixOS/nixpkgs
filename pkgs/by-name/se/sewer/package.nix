{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a4VdbZY8pYxrXIaUHJpnLuTB928tJn4UCdnt+m8UBug=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyopenssl
    requests
    tldextract
  ];

  meta = {
    homepage = "https://github.com/komuw/sewer";
    description = "ACME client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevincox ];
  };
}
