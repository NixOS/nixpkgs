{
  dmenu,
  fetchFromGitHub,
  lib,
  python3Packages,
  xdotool,
  xsel,
  xvfb-run,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "keepmenu";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "keepmenu";
    rev = finalAttrs.version;
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

  meta = {
    homepage = "https://github.com/firecat53/keepmenu";
    description = "Dmenu/Rofi frontend for Keepass databases";
    mainProgram = "keepmenu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ elliot ];
    platforms = lib.platforms.linux;
  };
})
