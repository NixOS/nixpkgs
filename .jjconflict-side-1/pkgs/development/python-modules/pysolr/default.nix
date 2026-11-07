{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  requests,
  mock,
}:

buildPythonPackage rec {
  pname = "pysolr";
  version = "3.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-u9DnRng1MWiA+ZS1U4bJvDwUZzPBfYWj/tMXdVl2xAo=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ mock ];

  doCheck = false; # requires network access

  meta = {
    description = "Lightweight Python wrapper for Apache Solr";
    homepage = "https://github.com/toastdriven/pysolr/";
    license = lib.licenses.bsd3;
  };
}
