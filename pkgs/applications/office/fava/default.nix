{ lib, python3, fetchpatch }:

python3.pkgs.buildPythonApplication rec {
  pname = "fava";
  version = "1.21";
  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-0aFCKEjmXn6yddgNMi9t4rzqHcN7VBLoz3LEg9apmNY=";
  };

  patches = [
    (fetchpatch {
      # Update werkzeug compatibility
      url = "https://github.com/beancount/fava/commit/5a99417a42e1d739b1e57fae2d01ff1d146dcbc2.patch";
      hash = "sha256-Y6IcxZAcFJEYgT8/xBIABdkP+pUdQX1EgSS5uNdSJUE=";
      excludes = [
        ".pre-commit-config.yaml"
      ];
    })
  ];

  nativeBuildInputs = with python3.pkgs; [ setuptools-scm ];

  propagatedBuildInputs = with python3.pkgs; [
    babel
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
