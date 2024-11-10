{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "distgen";
  version = "1.18";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lS6OeEaPiK8Pskuoww9KwyNhKnGQ+dHhdPmZn1Igj0Q=";
  };

  nativeCheckInputs = with python3.pkgs; [
    pytest
    mock
  ];

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jinja2
    six
    pyyaml
  ];

  checkPhase = "make test-unit PYTHON=${python3.executable}";

  meta = with lib; {
    description = "Templating system/generator for distributions";
    mainProgram = "dg";
    license = licenses.gpl2Plus;
    homepage = "https://distgen.readthedocs.io/";
    maintainers = with maintainers; [ bachp ];
  };
}
