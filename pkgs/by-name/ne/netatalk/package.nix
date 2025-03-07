{
  lib,
  stdenv,
  fetchurl,
  acl,
  autoreconfHook,
  avahi,
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
  docbook-xsl-nons,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk";
  version = "4.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-qCX2/37+2wm7nKdXJ6tDEmeXAA+Jd123LI2VIL9IHpw=";
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
    docbook-xsl-nons
    libxslt
  ];

  mesonFlags = [
    "-Dwith-appletalk=true"
    "-Dwith-bdb-path=${db.out}"
    "-Dwith-bdb-include-path=${db.dev}/include"
    "-Dwith-install-hooks=false"
    "-Dwith-init-hooks=false"
    "-Dwith-lockfile-path=/run/lock/"
    "-Dwith-cracklib=true"
    "-Dwith-cracklib-path=${cracklib.out}"
    "-Dwith-docbook-path=${docbook-xsl-nons.out}/share/xml/docbook-xsl-nons/"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Apple Filing Protocol Server";
    homepage = "https://netatalk.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jcumming ];
  };
})
