{
  lib,
  python3,
  fetchFromCodeberg,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "joystickwake";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "forestix";
    repo = "joystickwake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qIXXlwZec4CQk93gmY5O3mdGdlNCeXWTr/DDw4vwRUM=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    dbus-fast
    pyudev
    xlib
  ];

  postInstall = ''
    # autostart file
    ln -s $out/${python3.sitePackages}/etc $out/etc
  '';

  meta = {
    description = "Joystick-aware screen waker";
    mainProgram = "joystickwake";
    longDescription = ''
      Linux gamers often find themselves unexpectedly staring at a blank screen, because their display server fails to recognize game controllers as input devices, allowing the screen blanker to activate during gameplay.
      This program works around the problem by temporarily disabling screen blankers when joystick activity is detected.
    '';
    homepage = "https://github.com/foresto/joystickwake";
    maintainers = with lib.maintainers; [ bertof ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
