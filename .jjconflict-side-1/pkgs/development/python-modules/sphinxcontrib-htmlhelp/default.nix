{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-htmlhelp";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_htmlhelp";
    inherit version;
    hash = "sha256-yeKRas6KrWTME6DSM+4iMX8rkCW5zzKVJJ+phcxwguk=";
  };

  nativeBuildInputs = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension which renders HTML help files";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-htmlhelp";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}
