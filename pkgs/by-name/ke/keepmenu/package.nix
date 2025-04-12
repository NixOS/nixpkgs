{
  dmenu,
  fetchFromGitHub,
  lib,
  python3Packages,
  xdotool,
  xsel,
  xvfb-run,
}:

python3Packages.buildPythonApplication rec {
  pname = "keepmenu";
  version = "1.4.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "keepmenu";
    rev = version;
    hash = "sha256-Kzt2RqyYvOWnbkflwTHzlnpUaruVQvdGys57DDpH9o8=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = with python3Packages; [
    pykeepass
    pynput
  ];

  nativeCheckInputs = [
    dmenu
    xdotool
    xsel
    xvfb-run
  ];

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
    mainProgram = "keepmenu";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elliot ];
    platforms = platforms.linux;
  };
}
