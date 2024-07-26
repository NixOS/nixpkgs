{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "fava";
  version = "1.28";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sWHVkR0/0VMGzH5OMxOCK4usf7G0odzMtr82ESRQhrk=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools-scm ];
  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace-fail '"fava"' '"${placeholder "out"}/bin/fava"'
  '';

  propagatedBuildInputs = with python3Packages; [
    babel
    beancount
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

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools_scm>=8.0' 'setuptools_scm'
  '';

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  meta = with lib; {
    description = "Web interface for beancount";
    mainProgram = "fava";
    homepage = "https://beancount.github.io/fava";
    changelog = "https://beancount.github.io/fava/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
