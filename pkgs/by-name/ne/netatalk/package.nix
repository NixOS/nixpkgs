{
  lib,
  stdenv,
  fetchurl,
  acl,
  autoreconfHook,
  avahi,
<<<<<<< HEAD
  bstring,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  db,
  libevent,
  libgcrypt,
  libiconv,
  openssl,
  pam,
  perl,
  pkg-config,
  meson,
  ninja,
  file,
  cracklib,
  cups,
  libtirpc,
  openldap,
  glib,
  dbus,
  iniparser,
  pandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk";
<<<<<<< HEAD
  version = "4.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-KXe0/RExgvDMGDM3uiPVcB+yvk4N/Ox+5XW01zpzjTo=";
=======
  version = "4.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-Twe74RipUd10DT9RqHtcr7oklr0LIucEQ49CGqZnD5k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    file
  ];

  buildInputs = [
    acl
    avahi
<<<<<<< HEAD
    bstring
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    db
    libevent
    libgcrypt
    libiconv
    openssl
    pam
    cracklib
    cups
    libtirpc
    openldap
    glib
    perl
    dbus
    iniparser
    pandoc
  ];

  mesonFlags = [
    "-Dwith-appletalk=true"
    "-Dwith-statedir-path=/var/lib"
    "-Dwith-bdb-path=${db.out}"
    "-Dwith-bdb-include-path=${db.dev}/include"
    "-Dwith-install-hooks=false"
    "-Dwith-init-hooks=false"
<<<<<<< HEAD
    "-Dwith-lockfile-path=/run/lock"
=======
    "-Dwith-lockfile-path=/run/lock/"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "-Dwith-cracklib=true"
    "-Dwith-cracklib-path=${cracklib.out}"
    "-Dwith-statedir-creation=false"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Apple Filing Protocol Server";
    homepage = "https://netatalk.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      jcumming
      nulleric
    ];
=======
    maintainers = with lib.maintainers; [ jcumming ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
