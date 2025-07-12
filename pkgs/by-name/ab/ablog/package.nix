{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "ablog";
  version = "0.11.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = "ablog";
    tag = "v${version}";
    hash = "sha256-bPTaxkuIKeypfnZItG9cl51flHBIx/yg0qENuiqQgY4=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = with python3Packages; [ wheel ];

  dependencies = with python3Packages; [
    docutils
    feedgen
    invoke
    packaging
    python-dateutil
    sphinx
    watchdog
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    defusedxml
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::sphinx.deprecation.RemovedInSphinx90Warning"
    "--rootdir"
    "src/ablog"
    "-W"
    "ignore::sphinx.deprecation.RemovedInSphinx90Warning" # Ignore ImportError
  ];

  # assert "post 1" not in html
  # AssertionError
  disabledTests = [ "test_not_safe_for_parallel_read" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "ABlog for blogging with Sphinx";
    mainProgram = "ablog";
    homepage = "https://ablog.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rgrinberg ];
  };
}
