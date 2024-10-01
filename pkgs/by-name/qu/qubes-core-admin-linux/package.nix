{
  python3,
  fetchFromGitHub,
  qubes-linux-utils,
  pandoc,
  bash,
  patsh,
}: let
  inherit
    (python3.pkgs)
    buildPythonApplication
    setuptools
    distutils
    wrapPython
    qubes-core-admin-client
    ;

  version = "4.3.2";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-core-admin-linux";
    rev = "refs/tags/v${version}";
    hash = "sha256-duaH+T8ZbP/c0r2YABF3Pv9DnxI3n9sTO6Py2obeETQ=";
  };
in
  # FIXME: qfile-dom0-agent tries to call kdialog by absolute path
  buildPythonApplication {
    inherit version src;
    pname = "qubes-core-admin-linux";
    format = "custom";

    postPatch = ''
      substituteInPlace Makefile \
        --replace-fail "setup.py install" "setup.py install --prefix=."
    '';

    nativeBuildInputs = [
      setuptools
      distutils
      wrapPython
      pandoc
      patsh
    ];

    buildInputs = [
      qubes-linux-utils
      bash
    ];

    propagatedBuildInputs = [
      qubes-core-admin-client
    ];

    buildPhase = ''
      make -C dom0-updates $makeFlags
      make -C file-copy-vm $makeFlags
      make -C doc manpages $makeFlags
      make all $makeFlags
    '';

    dontUsePypaInstall = true;
    installPhase = ''
      runHook preInstall

      make install $makeFlags

      ### pm-utils
      mkdir -p $out/lib/pm-utils/sleep.d
      cp pm-utils/52qubes-pause-vms $out/lib/pm-utils/sleep.d/
      mkdir -p $out/lib/systemd/system
      cp pm-utils/qubes-suspend.service $out/lib/systemd/system/

      udevrulesdir=$out/etc/udev/rules.d
      install -d $udevrulesdir
      install -m 644 system-config/00-qubes-ignore-devices.rules $udevrulesdir
      install -m 644 system-config/12-qubes-ignore-lvm-devices.rules $udevrulesdir
      install -m 644 system-config/11-qubes-ignore-zvol-devices.rules $udevrulesdir
      install -m 644 system-config/99z-qubes-mark-ready.rules $udevrulesdir
      install -m 755 -D system-config/zvol_is_qubes_volume $out/lib/udev/zvol_is_qubes_volume
      # USBguard and PCIe device handling
      install -m 0755 -d -- "$out/etc/usbguard" "$out/etc/usbguard/rules.d"
      install -m 0644 -- system-config/qubes-usb-rules.conf "$out/etc/usbguard/rules.d/02-qubes.conf"

      # file copy to VM
      mkdir -p $out/lib/qubes/
      install -m 755 file-copy-vm/qfile-dom0-agent $out/lib/qubes/
      install -m 755 file-copy-vm/qvm-copy-to-vm $out/bin/
      install -m 755 file-copy-vm/qvm-copy $out/bin/
      ln -s qvm-copy-to-vm $out/bin/qvm-move-to-vm
      ln -s qvm-copy $out/bin/qvm-move

      runHook postInstall
    '';
    postInstall = ''
      wrapPythonProgramsIn $out/bin

      for i in $out/bin/{qvm-copy,qvm-copy-to-vm}; do
        substituteInPlace $i \
          --replace-fail "#!/bin/bash" "#!/usr/bin/env bash"
        patsh -f $i -s ${builtins.storeDir}
      done
      substituteInPlace $out/bin/qvm-copy-to-vm \
        --replace-fail "/usr/lib/qubes/" "$out/lib/qubes/"

      substituteInPlace $out/etc/udev/rules.d/11-qubes-ignore-zvol-devices.rules \
        --replace-fail "/usr/lib/udev/" "$out/lib/udev/"
    '';

    env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

    makeFlags = [
      "DESTDIR=$(out)"
      "BACKEND_VMM=xen"
    ];
  }
