{
  lib,
  stdenv,
  fetchurl,
  acl,
  autoreconfHook,
  avahi,
  bstring,
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
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk";
  version = "4.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-j8qwvzs5zYqU/j7nqCZMYABRWjrzd9o0FmlmCasTMW0=";
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
    bstring
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
    sqlite
  ];

  mesonFlags = [
    "-Dwith-appletalk=true"
    "-Dwith-statedir-path=/var/lib"
    "-Dwith-bdb-path=${db.out}"
    "-Dwith-bdb-include-path=${db.dev}/include"
    "-Dwith-install-hooks=false"
    "-Dwith-init-hooks=false"
    "-Dwith-lockfile-path=/run/lock"
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
    maintainers = with lib.maintainers; [
      jcumming
      nulleric
    ];
  };
})
