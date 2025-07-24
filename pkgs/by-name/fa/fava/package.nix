{
  lib,
  python3Packages,
  fetchPypi,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "fava";
  version = "1.30.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pfnRNhAcyuYFHqPBF0qCrK7w1PJiMOdYXCGj+xXi6uQ=";
  };

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace-fail '"fava"' '"${placeholder "out"}/bin/fava"'
  '';

  build-system = [ python3Packages.setuptools-scm ];

  dependencies = with python3Packages; [
    babel
    beancount
    beangulp
    beanquery
    cheroot
    click
    flask
    flask-babel
    jinja2
    markdown2
    ply
    simplejson
    werkzeug
    watchfiles
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # tests/test_cli.py
  __darwinAllowLocalNetworking = true;

  # flaky, fails only on ci
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_core_watcher.py" ];

  env = {
    # Disable some tests when building with beancount2
    SNAPSHOT_IGNORE = lib.versions.major python3Packages.beancount.version == "2";
  };

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  meta = {
    description = "Web interface for beancount";
    mainProgram = "fava";
    homepage = "https://beancount.github.io/fava";
    changelog = "https://beancount.github.io/fava/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bhipple
      sigmanificient
    ];
  };
}
