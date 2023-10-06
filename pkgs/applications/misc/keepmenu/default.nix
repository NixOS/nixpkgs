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

  propagatedBuildInputs = with python3Packages; [
    pykeepass
    pynput
  ];

  nativeCheckInputs = [ xvfb-run xdotool dmenu ];

  postPatch = ''
    substituteInPlace tests/keepmenu-config.ini tests/tests.py \
      --replace "/usr/bin/dmenu" "dmenu"
  '';

  checkPhase = ''
    runHook preCheck

    xvfb-run python tests/tests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "keepmenu" ];

  meta = with lib; {
    homepage = "https://github.com/firecat53/keepmenu";
    description = "Dmenu/Rofi frontend for Keepass databases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elliot ];
    platforms = platforms.linux;
  };
}
