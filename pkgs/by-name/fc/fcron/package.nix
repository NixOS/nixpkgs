# restart using 'killall -TERM fcron; fcron -b
# use convert-fcrontab to update fcrontab files

{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  autoreconfHook,
  perl,
  buildPackages,
  busybox,
  vim,
  sendmailProgram ?
    if lib.meta.availableOn stdenv.hostPlatform busybox then "${busybox}/sbin/sendmail" else null,
  editorProgram ? if lib.meta.availableOn stdenv.hostPlatform vim then "${vim}/bin/vi" else null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcron";
  version = "3.4.1";

  src = fetchurl {
    url = "http://fcron.free.fr/archives/fcron-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-dXF+ORbLzvvN5Y57/VFRUNdfdjI4Wy22vdL7wkKJ7NU=";
  };

  # fcron-test-for-fdatasync.patch below modifies configure.in and config.h.in,
  # so configure needs to be rebuilt.
  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ perl ];

  patches = [
    ./relative-fcronsighup.patch

    # Needed to build successfully on Darwin.
    # macOS has an fdatasync in its standard library, but doesn't declare it.
    # Apple Clang suppresses the resulting warning/error, but upstream Clang
    # doesn't. This patch tests for fdatasync support, and falls back to fsync.
    # Can be removed if <https://github.com/yo8192/fcron/pull/55> gets merged.
    (fetchpatch2 {
      name = "fcron-test-for-fdatasync.patch";
      url = "https://github.com/Rhys-T/fcron/commit/7382127f0c08b3e6b269ae4ee33eafe70f0993af.patch?full_index=1";
      hash = "sha256-cbexMYns7k7T1kQBoRdPfnKGeTQrmwxfwayJr2ryZwA=";
    })
  ];

  configureFlags = [
    "--with-sendmail=${if sendmailProgram == null then "no" else sendmailProgram}"
    "--with-editor=${if editorProgram == null then "no" else editorProgram}"
    "--with-bootinstall=no"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-rootname=root"
    "--with-rootgroup=root"
    "--disable-checks"
  ]
  ++ lib.optionals (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) [
    "ac_cv_func_memcmp_working=yes"
  ];

  installTargets = [ "install-staged" ]; # install does also try to change permissions of /etc/* files

  # fcron tries to install pid into system directory on install
  installFlags = [
    "ETC=."
    "PIDDIR=."
    "PIDFILE=fcron.pid"
    "REBOOT_LOCK=fcron.reboot"
    "FIFODIR=."
    "FIFOFILE=fcron.fifo"
    "FCRONTABS=."
  ];

  preConfigure = ''
    sed -i 's@/usr/bin/env perl@${lib.getExe buildPackages.perl}@g' configure script/*
    # Don't let fcron create the group fcron, nix(os) should do this
    sed -i '2s@.*@exit 0@' script/user-group

    # --with-bootinstall=no shoud do this, didn't work. So just exit the script before doing anything
    sed -i '2s@.*@exit 0@' script/boot-install

    # also don't use chown or chgrp for documentation (or whatever) when installing
    find -type f | xargs sed -i -e 's@^\(\s\)*chown@\1:@' -e 's@^\(\s\)*chgrp@\1:@'
  '';

  meta = {
    description = "Command scheduler with extended capabilities over cron and anacron";
    homepage = "http://fcron.free.fr";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
