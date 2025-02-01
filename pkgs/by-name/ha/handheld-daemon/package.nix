{
  lib,
  python3Packages,
  fetchFromGitHub,

  # dependencies
  systemd,
  hidapi,
  coreutils,
  kmod,
  efibootmgr,
  dbus,
  lsof,
}:
python3Packages.buildPythonApplication rec {
  pname = "handheld-daemon";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "hhd";
    tag = "v${version}";
    hash = "sha256-DkVdYnSEeaNZj76lhdU+9Pl0yzam2A2QGa3aHCmSHEA=";
  };

  # This package relies on several programs expected to be on the user's PATH.
  # We take a more reproducible approach by patching the absolute path to each of these required
  # binaries.
  postPatch = ''
    substituteInPlace src/hhd/controller/lib/hid.py \
      --replace-fail "libhidapi" "${lib.getLib hidapi}/lib/libhidapi"

    substituteInPlace src/hhd/controller/lib/hide.py \
      --replace-fail "/bin/chmod" "${lib.getExe' coreutils "chmod"}" \
      --replace-fail "udevadm" "${lib.getExe' systemd "udevadm"}"

    substituteInPlace src/hhd/controller/physical/evdev.py \
      --replace-fail "udevadm" "${lib.getExe' systemd "udevadm"}"

    substituteInPlace src/hhd/controller/physical/imu.py \
      --replace-fail '"modprobe' '"${lib.getExe' kmod "modprobe"}'

    substituteInPlace src/hhd/plugins/overlay/power.py \
      --replace-fail '"efibootmgr"' '"${lib.getExe' efibootmgr "id"}"'

    substituteInPlace src/hhd/device/oxp/serial.py \
      --replace-fail "udevadm" "${lib.getExe' systemd "udevadm"}"

    substituteInPlace src/hhd/plugins/overlay/systemd.py \
      --replace-fail "dbus-monitor" "${lib.getExe' dbus "dbus-monitor"}" \
      --replace-fail "systemd-inhibit" "${lib.getExe' systemd "systemd-inhibit"}"

    substituteInPlace src/hhd/plugins/overlay/x11.py \
      --replace-fail "lsof" "${lib.getExe lsof}"

    substituteInPlace src/hhd/plugins/plugin.py \
      --replace-fail '"id"' '"${lib.getExe' coreutils "id"}"'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    evdev
    pyserial
    pyyaml
    rich
    setuptools
    xlib
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  postInstall = ''
    install -Dm644 $src/usr/lib/udev/rules.d/83-hhd.rules -t $out/lib/udev/rules.d/
    install -Dm644 $src/usr/lib/udev/hwdb.d/83-hhd.hwdb -t $out/lib/udev/hwdb.d/
  '';

  meta = {
    homepage = "https://github.com/hhd-dev/hhd/";
    description = "Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win";
    platforms = lib.platforms.linux;
    changelog = "https://github.com/hhd-dev/hhd/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      appsforartists
      toast
    ];
    mainProgram = "hhd";
  };
}
