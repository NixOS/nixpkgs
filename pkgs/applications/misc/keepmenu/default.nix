<<<<<<< HEAD
{ lib, python3Packages, fetchFromGitHub, xvfb-run, xdotool, dmenu }:

python3Packages.buildPythonApplication rec {
  pname = "keepmenu";
  version = "1.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "keepmenu";
    rev = version;
    hash = "sha256-3vFg+9Nw+NhuPJbrmBahXwa13wXlBg5IMYwJ+unn88k=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = with python3Packages; [
    pykeepass
    pynput
  ];

<<<<<<< HEAD
  nativeCheckInputs = [ xvfb-run xdotool dmenu ];

  postPatch = ''
    substituteInPlace tests/keepmenu-config.ini tests/tests.py \
      --replace "/usr/bin/dmenu" "dmenu"
  '';

  checkPhase = ''
    runHook preCheck

    xvfb-run python tests/tests.py

    runHook postCheck
=======
  nativeCheckInputs = [ xvfb-run ];
  checkPhase = ''
    xvfb-run python setup.py test
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  pythonImportsCheck = [ "keepmenu" ];

  meta = with lib; {
    homepage = "https://github.com/firecat53/keepmenu";
    description = "Dmenu/Rofi frontend for Keepass databases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elliot ];
<<<<<<< HEAD
    platforms = platforms.linux;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
