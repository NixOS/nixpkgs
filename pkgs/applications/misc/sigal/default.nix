{ lib, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  version = "2.2";
  pname   = "sigal";

  src = python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "sha256-49XsNdZuicsiYJZuF1UdqMA4q33Ly/Ug/Hc4ybJKmPo=";
  };

  disabled = !(python3Packages.pythonAtLeast "3.6");

  propagatedBuildInputs = with python3Packages; [
    # install_requires
    jinja2
    markdown
    pillow
    pilkit
    click
    blinker
    natsort
    # extras_require
    brotli
    feedgenerator
    zopfli
    cryptography
  ];

  checkInputs = [
    ffmpeg
  ] ++ (with python3Packages; [
    pytestCheckHook
  ]);

  makeWrapperArgs = [ "--prefix PATH : ${ffmpeg}/bin" ];

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    homepage    = "http://sigal.saimon.org/en/latest/index.html";
    license     = licenses.mit;
    maintainers = with maintainers; [ domenkozar matthiasbeyer ];
  };
}
