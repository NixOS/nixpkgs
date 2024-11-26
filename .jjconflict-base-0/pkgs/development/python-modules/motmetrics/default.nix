{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  pandas,
  scipy,
  xmltodict,

  # tests
  pytestCheckHook,
  pytest-benchmark,
}:

buildPythonPackage rec {
  pname = "motmetrics";
  version = "1.4.0-unstable-20240130";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cheind";
    repo = "py-motmetrics";
    # latest release is not compatible with pandas 2.0
    rev = "7210fcce0be1b76c96a62f6fe4ddbc90d944eacb";
    hash = "sha256-7LKLHXWgW4QpivAgzvWl6qEG0auVvpiZ6bfDViCKsFY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    pandas
    scipy
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
  ];

  pythonImportsCheck = [ "motmetrics" ];

  meta = with lib; {
    description = "Bar_chart: Benchmark multiple object trackers (MOT) in Python";
    homepage = "https://github.com/cheind/py-motmetrics";
    license = licenses.mit;
    maintainers = [ ];
  };
}
