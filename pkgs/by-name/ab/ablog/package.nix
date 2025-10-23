{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
}:

let
  version = "0.11.12";
in
python3Packages.buildPythonApplication {
  pname = "ablog";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = "ablog";
    tag = "v${version}";
    hash = "sha256-bPTaxkuIKeypfnZItG9cl51flHBIx/yg0qENuiqQgY4=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    wheel
  ];

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

  pytestFlags = [
    "--rootdir=src/ablog"
    "-Wignore::sphinx.deprecation.RemovedInSphinx90Warning" # Ignore ImportError
  ];

  disabledTests = [
    # upstream investigation is still ongoing
    # https://github.com/sunpy/ablog/issues/302
    "test_not_safe_for_parallel_read"
    # need sphinx old version
    "test_feed"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Sphinx extension that converts any documentation or personal website project into a full-fledged blog";
    mainProgram = "ablog";
    homepage = "https://ablog.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rgrinberg ];
  };
}
