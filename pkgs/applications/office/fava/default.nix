{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "fava";
  version = "1.27.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W/uxzk+/4tDVOL+nVUJfyBAE5sI9/pYq1zu42GCGjSk=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools-scm ];

  propagatedBuildInputs = with python3.pkgs; [
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
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools_scm>=8.0' 'setuptools_scm'
  '';

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  disabledTests = [
    # runs fava in debug mode, which tries to interpret bash wrapper as Python
    "test_cli"
  ];

  meta = with lib; {
    description = "Web interface for beancount";
    homepage = "https://beancount.github.io/fava";
    changelog = "https://beancount.github.io/fava/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
