{ lib
, python3
, fetchFromGitHub
, gitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ablog";
  version = "0.11.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = "ablog";
    rev = "v${version}";
    hash = "sha256-t3Vxw1IJoHuGqHv/0S4IoHwjWbtR6knXCBg4d0cM3lw=";
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
    defusedxml
  ];

  pytestFlagsArray = [
    "-W" "ignore::sphinx.deprecation.RemovedInSphinx90Warning"
    "--rootdir" "src/ablog"
    "-W" "ignore::sphinx.deprecation.RemovedInSphinx90Warning" # Ignore ImportError
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "ABlog for blogging with Sphinx";
    mainProgram = "ablog";
    homepage = "https://ablog.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrinberg ];
  };
}
