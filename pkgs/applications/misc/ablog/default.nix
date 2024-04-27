{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ablog";
  version = "0.11.8";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PpNBfa4g14l8gm9+PxOFc2NDey031D7Ohutx2OGUeak=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    docutils
    feedgen
    invoke
    packaging
    python-dateutil
    sphinx
    watchdog
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::sphinx.deprecation.RemovedInSphinx90Warning"
    "--rootdir" "src/ablog"
    "-W" "ignore::sphinx.deprecation.RemovedInSphinx90Warning" # Ignore ImportError
  ];

  meta = with lib; {
    description = "ABlog for blogging with Sphinx";
    mainProgram = "ablog";
    homepage = "https://ablog.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrinberg ];
  };
}
