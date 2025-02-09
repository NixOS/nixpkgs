{
  lib,
  python3Packages,
  fetchPypi,
}:

let
  version = "2.0.3";
in
python3Packages.buildPythonApplication {
  pname = "ddsmt";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ddSMT";
    hash = "sha256-nmhEG4sUmgpgRUduVTtwDLGPJVKx+dEaPb+KjFRwV2Q=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    gprof2dot
    progressbar
  ];

  meta = {
    description = "Delta debugger for SMT benchmarks in SMT-LIB v2";
    homepage = "https://ddsmt.readthedocs.io/";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
  };
}
