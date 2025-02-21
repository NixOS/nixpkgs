{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "mdbook-pdf-outline";
  version = "0.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-STi+54iT+5+Xi0IzGXv2dxVS91+T6fjg3xmbJjekpPE=";
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
    maintainers = with maintainers; [ nix-julia ];

  };
}
