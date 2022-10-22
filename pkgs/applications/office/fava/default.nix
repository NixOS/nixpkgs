{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fava";
  version = "1.22.3";
  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-e8/VOn0WmrUO69x/4hKGtgKuj11U1Qv7OUhfOL/p5Ds=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools-scm ];

  propagatedBuildInputs = with python3.pkgs; [
    babel
    beancount
    cheroot
    click
    flask
    flask-babel
    jaraco_functools
    jinja2
    markdown2
    ply
    simplejson
    werkzeug
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

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
