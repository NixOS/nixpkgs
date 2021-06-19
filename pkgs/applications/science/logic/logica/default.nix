{ lib, buildPythonApplication, python, fetchPypi, isPy27 }:

buildPythonApplication rec {
  pname = "logica";
  version = "1.3.13";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "72c764fa5c20ee280af7386e739be2430c67832da59f12aa458bdca491866de1";
  };

  # PyPI tarball doesn't ship README.md
  postPatch = ''
    touch logica/README.md
  '';

  checkPhase = ''
    ${python.interpreter} logica/run_all_tests.py
  '';

  # PyPI tarball doesn't ship all the tests files, and upstream repository does
  # not have a setup.py
  doCheck = false;

  meta = with lib; {
    homepage = "https://logica.dev/";
    description = "A logic programming language that compiles to StandardSQL and runs on Google BigQuery";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
