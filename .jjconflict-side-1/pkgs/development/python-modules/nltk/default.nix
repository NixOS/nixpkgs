{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  click,
  joblib,
  regex,
  tqdm,
}:

buildPythonPackage rec {
  pname = "nltk";
  version = "3.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h9EnvT3kvYmk+BJl5fpZyxsZmydEAXU3D3QX0rx66Gg=";
  };

  propagatedBuildInputs = [
    click
    joblib
    regex
    tqdm
  ];

  # Tests require some data, the downloading of which is impure. It would
  # probably make sense to make the data another derivation, but then feeding
  # that into the tests (given that we need nltk itself to download the data,
  # unless there's an easy way to download it without nltk's downloader) might
  # be complicated. For now let's just disable the tests and hope for the
  # best.
  doCheck = false;

  pythonImportsCheck = [ "nltk" ];

  meta = with lib; {
    description = "Natural Language Processing ToolKit";
    mainProgram = "nltk";
    homepage = "http://nltk.org/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
