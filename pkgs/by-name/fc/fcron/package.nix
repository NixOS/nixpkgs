# restart using 'killall -TERM fcron; fcron -b
# use convert-fcrontab to update fcrontab files

{
  lib,
  stdenv,
  fetchurl,
  perl,
<<<<<<< HEAD
  buildPackages,
  busybox,
  vim,
  sendmailProgram ?
    if lib.meta.availableOn stdenv.hostPlatform busybox then "${busybox}/sbin/sendmail" else null,
  editorProgram ? if lib.meta.availableOn stdenv.hostPlatform vim then "${vim}/bin/vi" else null,
=======
  busybox,
  vim,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation rec {
  pname = "fcron";
  version = "3.4.0";

  src = fetchurl {
    url = "http://fcron.free.fr/archives/${pname}-${version}.src.tar.gz";
    sha256 = "sha256-9Of8VTzdcP9LO2rJE4s7fP+rkZi4wmbZevCodQbg4bU=";
  };

  buildInputs = [ perl ];

  patches = [ ./relative-fcronsighup.patch ];

  configureFlags = [
<<<<<<< HEAD
    "--with-sendmail=${if sendmailProgram == null then "no" else sendmailProgram}"
    "--with-editor=${if editorProgram == null then "no" else editorProgram}"
=======
    "--with-sendmail=${busybox}/sbin/sendmail"
    "--with-editor=${vim}/bin/vi" # TODO customizable
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "--with-bootinstall=no"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-rootname=root"
    "--with-rootgroup=root"
    "--disable-checks"
<<<<<<< HEAD
  ]
  ++ lib.optionals (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) [
    "ac_cv_func_memcmp_working=yes"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    sed -i 's@/usr/bin/env perl@${lib.getExe buildPackages.perl}@g' configure script/*
=======
    sed -i 's@/usr/bin/env perl@${perl}/bin/perl@g' configure script/*
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # Don't let fcron create the group fcron, nix(os) should do this
    sed -i '2s@.*@exit 0@' script/user-group

    # --with-bootinstall=no shoud do this, didn't work. So just exit the script before doing anything
    sed -i '2s@.*@exit 0@' script/boot-install

    # also don't use chown or chgrp for documentation (or whatever) when installing
    find -type f | xargs sed -i -e 's@^\(\s\)*chown@\1:@' -e 's@^\(\s\)*chgrp@\1:@'
  '';

<<<<<<< HEAD
  meta = {
    description = "Command scheduler with extended capabilities over cron and anacron";
    homepage = "http://fcron.free.fr";
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "Command scheduler with extended capabilities over cron and anacron";
    homepage = "http://fcron.free.fr";
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.all;
  };
}
