{ lib, buildPythonApplication, fetchPypi, pythonPackages, ffmpeg }:

buildPythonApplication rec {
  version = "1.4.0";
  pname   = "sigal";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0da0n8jhjp2swr18zga87xc77r8c7qwqf5sp222ph9sn3yyyc35i";
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

  makeWrapperArgs = [ "--prefix PATH : ${ffmpeg}/bin" ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    homepage    = http://sigal.saimon.org/en/latest/index.html;
    license     = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}

