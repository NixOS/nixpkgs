{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ablog";
  version = "0.11.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fV4W4AaiqyruIz3OQ7/lGkMPMKmyiFa+fdU2QeeQCvs=";
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
    homepage = "https://ablog.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrinberg ];
  };
}
