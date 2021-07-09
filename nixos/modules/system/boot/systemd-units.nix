{ runCommand, lib, systemd, extraUnits, unitOverrides }:

runCommand "systemd-units" { } ''
  set -euo pipefail
  mkdir $out
  (cd ${systemd}/example/systemd; find . -type f -o -type l) | while read -r f; do
    mkdir -p $out/$(dirname "$f")
    cp -d "${systemd}/example/systemd/$f" "$out/$f"
  done

  mkdir $out/system/initrd.target.wants

  # For some reason, running 'udevadm info --cleanup-db' in initrd causes
  # LUKS devices to get SYSTEMD_READY=0 in stage 2 (but not other devices)
  # which prevents LUKS encrypted file systems from being mounted in stage 2.
  rm $out/system/initrd-udevadm-cleanup-db.service

  ln -s ../plymouth-start.service $out/system/initrd.target.wants/plymouth-start.service

  rm $out/system/proc-sys-fs-binfmt_misc.automount
  rm $out/system/systemd-random-seed.service
  rm $out/system/systemd-update-utmp.service
  rm $out/system/systemd-update-done.service
  rm $out/system/systemd-sysctl.service
  rm $out/system/systemd-hwdb-update.service

  rm $out/system/default.target
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
