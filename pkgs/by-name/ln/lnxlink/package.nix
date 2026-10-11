{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  # Extra python packages to make importable by lnxlink. Its optional modules pull their dependencies in
  # lazily through `import_install_package`, which shells out to `pip install` first and only falls back
  # to a plain import when that fails - so on NixOS a module works exactly when its dependencies are
  # already in this environment, and otherwise logs "Can't install package" and stays off.
  # `passthru.optional-dependencies` below groups them by the lnxlink module that needs them.
  extraPythonPackages ? (ps: [ ]),
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lnxlink";
  version = "2026.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bkbilly";
    repo = "lnxlink";
    tag = finalAttrs.version;
    hash = "sha256-OYhknM2ApxRWdFpPdY1vhxxd7Mfp9watUNKoKrBr0qE=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    (with python3Packages; [
      aiohttp
      beaupy
      distro
      inotify
      jeepney
      paho-mqtt
      psutil
      pyyaml
      requests
    ])
    ++ extraPythonPackages python3Packages;

  # Upstream configures pytest but ships no tests.
  doCheck = false;

  pythonImportsCheck = [ "lnxlink" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.optional-dependencies =
    # Keyed by lnxlink module name rather than by a pyproject extra: upstream declares no extras, it
    # lists these under a "Modules dependencies" heading in requirements.txt and imports them lazily.
    # `fingerprint` is missing because adafruit-circuitpython-fingerprint is not in nixpkgs yet.
    with python3Packages; {
      active_window = [
        ewmh
        python-xlib
      ];
      audio_select = [ pulsectl ];
      docker = [ docker ];
      fullscreen = [
        ewmh
        python-xlib
      ];
      gpio = [ rpi-gpio ];
      gpu = [
        nvitop
        nvsmi
        pyamdgpuinfo
      ];
      idle = [ dbus-idle ];
      ir_remote = [ pigpio ];
      keyboard_hotkeys = [ xlib-hotkeys ];
      media = [
        dbus-mediaplayer
        pillow
      ];
      mounts = [ pygobject3 ];
      notify = [ dbus-notification ];
      restful = [
        flask
        waitress
      ];
      screenshot = [ opencv-python-headless ];
      speech_recognition = [
        pyalsaaudio
        speechrecognition
      ];
      steam = [ vdf ];
      webcam = [ opencv-python-headless ];
      wifi = [ dbus-networkdevices ];
    };

  meta = {
    description = "Internet of Things (IoT) integration with Linux using MQTT";
    longDescription = ''
      LNXlink exposes a Linux machine to Home Assistant over MQTT: sensors for CPU, memory, disk,
      network, battery and media, and controls for suspend, shutdown, screenshots, notifications and
      arbitrary shell commands. Each capability is a module that can be enabled individually; modules
      shell out to system utilities and pull optional python dependencies in on demand, so give it what
      the modules you enable need (see `passthru.optional-dependencies`).
    '';
    homepage = "https://github.com/bkbilly/lnxlink";
    downloadPage = "https://github.com/bkbilly/lnxlink/releases";
    changelog = "https://github.com/bkbilly/lnxlink/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "lnxlink";
    maintainers = with lib.maintainers; [
      giggio
      bkbilly
    ];
    platforms = lib.platforms.linux;
  };
})
