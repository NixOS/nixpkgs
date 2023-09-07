{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "fava";
  version = "1.26";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YSxUqwmv7LQqnT9U1dau9pYaKvEEG5Tbi7orylJKkp0=";
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
