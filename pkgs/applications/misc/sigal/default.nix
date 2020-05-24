{ lib, python3Packages, pythonAtLeast, ffmpeg }:

python3Packages.buildPythonApplication rec {
  version = "2.1";
  pname   = "sigal";

  src = python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "1ddjijpdg0hk8xzqsgnxicivscyh9lz9cxikkxi8yr9hw2wgwjnm";
  };

  disabled = python3Packages.pythonAtLeast "3.6.0";

  checkInputs = with python3Packages; [ pytest ];
  propagatedBuildInputs = with python3Packages; [
    jinja2
    markdown
    pillow
    pilkit
    clint
    click
    blinker
    natsort
    setuptools_scm
  ];

  makeWrapperArgs = [ "--prefix PATH : ${ffmpeg_3}/bin" ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    homepage    = "http://sigal.saimon.org/en/latest/index.html";
    license     = licenses.mit;
    maintainers = with maintainers; [ domenkozar matthiasbeyer ];
  };
}
