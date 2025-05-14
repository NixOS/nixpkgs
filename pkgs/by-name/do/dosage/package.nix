{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "dosage";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mHV/U9Vqv7fSsLYNrCXckkJ1YpsccLd8HsJ78IwLX0Y=";
  };

  pyproject = true;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-xdist
    responses
  ];

  build-system = [ python3Packages.setuptools-scm ];

  dependencies = with python3Packages; [
    colorama
    imagesize
    lxml
    requests
    six
    platformdirs
  ];

  disabledTests = [
    # need network connect to api.github.com
    "test_update_available"
    "test_no_update_available"
    "test_update_broken"
    "test_current"
  ];

  meta = {
    description = "Comic strip downloader and archiver";
    mainProgram = "dosage";
    homepage = "https://dosage.rocks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toonn ];
  };
}
