{ runCommand, lib, systemd, extraUnits, unitOverrides }:

runCommand "systemd-units" { } ''
  set -euo pipefail
  mkdir $out
  (cd ${systemd}/example/systemd; find . -type f) | while read -r f; do
    mkdir -p $out/$(dirname "$f")
    cp "${systemd}/example/systemd/$f" "$out/$f"
  done

  # TODO: I believe much of this can be fixed by using -type l and cp -d above,
  # but that brings a lot more units with a lot more problems.
  mkdir $out/system/initrd.target.wants
  ln -s ../systemd-udevd.service $out/system/initrd.target.wants/systemd-udevd.service
  ln -s ../systemd-modules-load.service $out/system/initrd.target.wants/systemd-modules-load.service
  ln -s ../systemd-journald.service $out/system/initrd.target.wants/systemd-journald.service
  ln -s ../systemd-ask-password-console.service $out/system/initrd.target.wants/systemd-ask-password-console.service
  ln -s ../systemd-vconsole-setup.service $out/system/initrd.target.wants/systemd-vconsole-setup.service
  ln -s ../systemd-udev-settle.service $out/system/initrd.target.wants/systemd-udev-settle.service
  ln -s ../systemd-udev-trigger.service $out/system/initrd.target.wants/systemd-udev-trigger.service
  mkdir $out/system/sysinit.target.wants
  ln -s ../cryptsetup.target $out/system/sysinit.target.wants

  # For some reason, running 'udevadm info --cleanup-db' in initrd causes
  # LUKS devices to get SYSTEMD_READY=0 in stage 2 (but not other devices)
  # which prevents LUKS encrypted file systems from being mounted in stage 2.
  rm $out/system/initrd-udevadm-cleanup-db.service

  ln -s initrd.target $out/system/default.target

  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: u: ''
    ln -s ${u} $out/system/${n}
    ln -s ../${n} $out/system/initrd.target.wants/${n}
  '') extraUnits)}

  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: os: ''
    mkdir $out/system/${n}.d
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (oname: o: ''
      ln -s ${o} $out/system/${n}.d/${oname}.conf
    '') os)}
  '') unitOverrides)}
''
