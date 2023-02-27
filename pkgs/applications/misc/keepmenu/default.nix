{ lib, python3Packages, python3, xvfb-run }:

python3Packages.buildPythonApplication rec {
  pname = "keepmenu";
  version = "1.2.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "SeVNtONH1bn2hb2pBOVM3Oafrb+jARgfvRe7vUu6Gto=";
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
