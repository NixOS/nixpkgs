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
  cmark-gfm,
  iniparser,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk";
  version = "4.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-doqRAU4pjcHRTvKOvjMN2tSZKOPDTzBzU7i90xf1ClI=";
  };

  patches = [
    ./0000-no-install-under-usr-cupsd.patch
    ./0001-no-install-under-var-CNID.patch
  ];

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
    cmark-gfm
    iniparser
  ];

  mesonFlags = [
    "-Dwith-appletalk=true"
    "-Dwith-statedir-path=/var/lib"
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
