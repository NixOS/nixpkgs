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
  btrfs-progs,
  util-linux,
}:
python3Packages.buildPythonApplication rec {
  pname = "handheld-daemon";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "hhd";
    tag = "v${version}";
    hash = "sha256-Lh9rilpdx+njikVDftFAeA5HWgWQwgfnzocT/nSO2NU=";
  };

  # Handheld-daemon runs some selinux-related utils which are not in nixpkgs.
  # NixOS doesn't support selinux so we can safely remove them
  patches = [ ./0001-remove-selinux-fixes.patch ];

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

    substituteInPlace src/hhd/plugins/power/power.py \
      --replace-fail '"efibootmgr"' '"${lib.getExe' efibootmgr "id"}"' \
      --replace-fail '"systemctl' '"${lib.getExe' systemd "systemctl"}' \
      --replace-fail '"stat"' '"${lib.getExe' coreutils "stat"}"' \
      --replace-fail '"swapon"' '"${lib.getExe' util-linux "swapon"}"' \
      --replace-fail '"swapoff"' '"${lib.getExe' util-linux "swapoff"}"' \
      --replace-fail '"fallocate"' '"${lib.getExe' util-linux "fallocate"}"' \
      --replace-fail '"chmod"' '"${lib.getExe' coreutils "chmod"}"' \
      --replace-fail '"mkswap"' '"${lib.getExe' util-linux "mkswap"}"' \
      --replace-fail '"btrfs",' '"${lib.getExe' btrfs-progs "btrfs"}",'

    substituteInPlace src/hhd/device/oxp/serial.py \
      --replace-fail "udevadm" "${lib.getExe' systemd "udevadm"}"

    substituteInPlace src/hhd/plugins/overlay/systemd.py \
      --replace-fail "dbus-monitor" "${lib.getExe' dbus "dbus-monitor"}" \
      --replace-fail "systemd-inhibit" "${lib.getExe' systemd "systemd-inhibit"}"

    substituteInPlace src/hhd/plugins/overlay/x11.py \
      --replace-fail "lsof" "${lib.getExe lsof}"

    substituteInPlace src/hhd/plugins/plugin.py \
      --replace-fail '"id"' '"${lib.getExe' coreutils "id"}"'

    substituteInPlace usr/lib/udev/rules.d/83-hhd.rules \
      --replace-fail '/bin/chmod' '${lib.getExe' coreutils "chmod"}'

    substituteInPlace src/adjustor/core/acpi.py \
      --replace-fail '"modprobe"' '"${lib.getExe' kmod "modprobe"}"'
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
    pyroute2
    pygobject3
    dbus-python
  ];

  # This package doesn't have upstream tests.
  doCheck = false;

  pythonImportsCheck = [
    "hhd"
    "adjustor"
  ];

  postInstall = ''
    install -Dm644 usr/lib/udev/rules.d/83-hhd.rules -t $out/lib/udev/rules.d/
    install -Dm644 usr/lib/udev/hwdb.d/83-hhd.hwdb -t $out/lib/udev/hwdb.d/
  '';

  meta = {
    homepage = "https://github.com/hhd-dev/hhd/";
    description = "Linux support for handheld gaming devices like the Legion Go, ROG Ally, and GPD Win";
    platforms = lib.platforms.linux;
    changelog = "https://github.com/hhd-dev/hhd/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      toast
    ];
    mainProgram = "hhd";
  };
}
