{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "joystickwake";
  version = "0.4.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "foresto";
    repo = "joystickwake";
    tag = "v${version}";
    sha256 = "sha256-vSvIpbcDIbRyitVjx3wNSxt5vTIZ9/NPWokOJt0p6oQ=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    dbus-next
    pyudev
    xlib
  ];

  postInstall = ''
    # autostart file
    ln -s $out/${python3.sitePackages}/etc $out/etc
  '';

  meta = with lib; {
    description = "Joystick-aware screen waker";
    mainProgram = "joystickwake";
    longDescription = ''
      Linux gamers often find themselves unexpectedly staring at a blank screen, because their display server fails to recognize game controllers as input devices, allowing the screen blanker to activate during gameplay.
      This program works around the problem by temporarily disabling screen blankers when joystick activity is detected.
    '';
    homepage = "https://github.com/foresto/joystickwake";
    maintainers = with maintainers; [ bertof ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
