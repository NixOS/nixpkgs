{
  buildPythonPackage,
  docopt,
  fastavro,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "hdfs";
  version = "2.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mtth";
    repo = "hdfs";
    rev = "refs/tags/v${version}";
    hash = "sha256-Pm2E8hB0wbu7npi/sLt9D8jQsH69qNOHLji9CYqST/8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docopt
    requests
    six
  ];

  nativeCheckInputs = [
    fastavro
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hdfs" ];

  meta = with lib; {
    description = "Python API and command line interface for HDFS";
    homepage = "https://github.com/mtth/hdfs";
    changelog = "https://github.com/mtth/hdfs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
    mainProgram = "hdfscli";
  };
}
