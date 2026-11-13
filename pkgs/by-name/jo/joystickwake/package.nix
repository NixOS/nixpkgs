{
  lib,
  fetchFromCodeberg,
  installShellFiles,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "joystickwake";
  version = "1.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "forestix";
    repo = "joystickwake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p2zhoOLO3WLyn5U6X1c4diywNBmOZNb7Y9l9RoZDlQo=";
  };

  # Make the path relative to put it under $out instead of /etc
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/etc/xdg/autostart" "etc/xdg/autostart"
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    installShellFiles
    python3Packages.docutils
  ];

  dependencies = with python3Packages; [
    dbus-fast
    pyudev
    python-xlib
  ];

  postInstall = ''
    rst2man README.rst joystickwake.1
    installManPage joystickwake.1
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Joystick-aware screen waker";
    longDescription = ''
      Linux gamers often find themselves unexpectedly staring at a blank screen, because their display server fails to recognize game controllers as input devices, allowing the screen blanker to activate during gameplay.
      This program works around the problem by suppressing screen blankers while joystick activity is detected.
    '';
    homepage = "https://codeberg.org/forestix/joystickwake";
    changelog = "https://codeberg.org/forestix/joystickwake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bertof ];
    platforms = lib.platforms.linux;
    mainProgram = "joystickwake";
  };
})
