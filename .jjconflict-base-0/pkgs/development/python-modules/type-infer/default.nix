{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  poetry-core,
  colorlog,
  dataclasses-json,
  langid,
  nltk,
  numpy,
  pandas,
  psutil,
  py3langid,
  python-dateutil,
  scipy,
  toml,
  nltk-data,
  symlinkJoin,
}:
let
  testNltkData = symlinkJoin {
    name = "nltk-test-data";
    paths = [
      nltk-data.punkt
      nltk-data.stopwords
    ];
  };
in
buildPythonPackage rec {
  pname = "type-infer";
  version = "0.0.20";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  # using PyPI because the repo does not have tags or release branches
  src = fetchPypi {
    pname = "type_infer";
    inherit version;
    hash = "sha256-F+gfA7ofrbMEE5SrVt9H3s2mZKQLyr6roNUmL4EMJbI=";
  };

  pythonRelaxDeps = [ "psutil" ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    colorlog
    dataclasses-json
    langid
    nltk
    numpy
    pandas
    psutil
    py3langid
    python-dateutil
    scipy
    toml
  ];

  # PyPI package does not include tests
  doCheck = false;

  # Package import requires NLTK data to be downloaded
  # It is the only way to set NLTK_DATA environment variable,
  # so that it is available in pythonImportsCheck
  env.NLTK_DATA = testNltkData;
  pythonImportsCheck = [ "type_infer" ];

  meta = with lib; {
    description = "Automated type inference for Machine Learning pipelines";
    homepage = "https://pypi.org/project/type-infer/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
