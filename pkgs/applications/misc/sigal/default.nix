{ lib, python3Packages, ffmpeg_3 }:

python3Packages.buildPythonApplication rec {
  version = "2.0";
  pname   = "sigal";

  src = python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "0ff8hpihbd30xjy155ksfpypjskilqg4zmyavgvpri8jaf1qpv89";
  };

  checkInputs = with python3Packages; [ pytest ];
  propagatedBuildInputs = with python3Packages; [
    jinja2
    markdown
    pillow
    pilkit
    clint
    click
    blinker
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
