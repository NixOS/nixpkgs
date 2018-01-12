{ lib, buildPythonApplication, fetchPypi, pythonPackages }:

buildPythonApplication rec {
  version = "1.3.0";
  pname   = "sigal";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0ycyrap4rc0yrjagi5c5fs5gpw9whvkli656syfpj99dq1q9q1d0";
  };

  buildInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = with pythonPackages; [
    jinja2
    markdown
    pillow
    pilkit
    clint
    click
    blinker
  ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    homepage    = http://sigal.saimon.org/en/latest/index.html;
    license     = licenses.mit;
    maintainers = with maintainers; [ domenkozar matthiasbeyer ];
  };
}

