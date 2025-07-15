{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-subidy";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Prior99";
    repo = "mopidy-subidy";
    tag = version;
    sha256 = "0c5ghhhrj5v3yp4zmll9ari6r5c6ha8c1izwqshvadn40b02q7xz";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.py-sonic
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_subidy" ];

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from a Subsonic-compatible Music Server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wenngle ];
  };
}
