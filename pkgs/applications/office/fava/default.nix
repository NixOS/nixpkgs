{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fava";
  version = "1.19";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "def7c0210bf0ce8dfffdb46ce21b3efcf71eba5a4e903565258419e4c53c2d43";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools-scm ];

  propagatedBuildInputs = with python3.pkgs; [
    Babel
    beancount
    cheroot
    click
    flask
    flaskbabel
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
