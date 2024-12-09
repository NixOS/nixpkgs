{ lib
, python3
, fetchPypi
}:

let
  pname = "pybibget";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M6CIctTOVn7kIPmsoHQmYl2wQaUzfel7ryw/3ebQitg=";
  };

in
python3.pkgs.buildPythonApplication  {
  inherit pname version src;
  pyproject = true;

  propagatedBuildInputs = with python3.pkgs; [
    lxml
    httpx
    appdirs
    aiolimiter
    pybtex
    pylatexenc
    numpy
    networkx
    requests
  ];

  # Tests for this applicaiton do not run on NixOS, and binaries were
  # manually tested instead
  doCheck = false;

  meta = {
    description = "Command line utility to automatically retrieve BibTeX citations from MathSciNet, arXiv, PubMed and doi.org";
    homepage = "https://github.com/wirhabenzeit/pybibget";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vasissualiyp ];
  };
}
