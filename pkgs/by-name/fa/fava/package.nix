{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "fava";
  version = "1.30";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HBvsFflKGPVlHc9pHB8VCGGD1WLDT9TbjL1V41C3hKU=";
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
    jaraco-functools
    jinja2
    markdown2
    ply
    simplejson
    werkzeug
    watchfiles
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  preCheck =
    ''
      export HOME=$TEMPDIR
    ''
    # Disable some tests when building with beancount2
    + lib.optionalString (lib.versions.major python3Packages.beancount.version == "2") ''
      export SNAPSHOT_IGNORE=true
    '';

  meta = with lib; {
    description = "Web interface for beancount";
    mainProgram = "fava";
    homepage = "https://beancount.github.io/fava";
    changelog = "https://beancount.github.io/fava/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [
      bhipple
      sigmanificient
    ];
  };
}
