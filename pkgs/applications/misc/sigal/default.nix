{ lib, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  version = "1.4.1";
  pname   = "sigal";

  src = python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "1fg32ii26j3xpq3cryi212lx9z33qnicm1cszwv1wfpg6sr2rr61";
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

  makeWrapperArgs = [ "--prefix PATH : ${ffmpeg}/bin" ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    homepage    = http://sigal.saimon.org/en/latest/index.html;
    license     = licenses.mit;
    maintainers = with maintainers; [ domenkozar matthiasbeyer ];
  };
}
