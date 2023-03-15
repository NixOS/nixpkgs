{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fava";
  version = "1.24";
  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-Ep+8O93L/CG4qcBFzCBMRasK/ySp8+cU59LcyZRTJtg=";
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
