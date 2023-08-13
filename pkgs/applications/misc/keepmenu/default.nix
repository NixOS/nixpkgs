{ lib, python3Packages, fetchPypi, xvfb-run }:

python3Packages.buildPythonApplication rec {
  pname = "keepmenu";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AGuJY7IirzIjcu/nY9CzeOqU1liwcRijYLi8hGN/pRg=";
  };

  preConfigure = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/.config/keepmenu
    cp config.ini.example $HOME/.config/keepmenu/config.ini
  '';

  propagatedBuildInputs = with python3Packages; [
    pykeepass
    pynput
  ];

  nativeCheckInputs = [ xvfb-run ];
  checkPhase = ''
    xvfb-run python setup.py test
  '';

  pythonImportsCheck = [ "keepmenu" ];

  meta = with lib; {
    homepage = "https://github.com/firecat53/keepmenu";
    description = "Dmenu/Rofi frontend for Keepass databases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elliot ];
  };
}
