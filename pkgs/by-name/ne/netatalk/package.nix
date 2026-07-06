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
  talloc,
  xapian,
  flex,
  bison,
  dconf,
  localsearch,
  tinysparql,
  xapianSupport ? false,
  localsearchSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk";
  version = "4.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-Ytd/WkkeaQhsFwb/fZ4BaRLg5ItD0MOnrmDDhLbWJbM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    file
  ]
  ++ lib.optionals localsearchSupport [
    flex
    bison
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
    talloc
  ]
  ++ lib.optionals xapianSupport [
    xapian
    file
  ]
  ++ lib.optionals localsearchSupport [
    tinysparql
    dconf
    localsearch
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
    "-Dwith-spotlight-backends=${
      lib.concatStringsSep "," (
        [ "cnid" ] ++ lib.optional xapianSupport "xapian" ++ lib.optional localsearchSupport "localsearch"
      )
    }"
  ];

  # TODO: drop once upstream makes this path configurable.
  postPatch = lib.optionalString localsearchSupport ''
    substituteInPlace meson.build \
      --replace-fail "install_emptydir('/etc/dconf/db')" "install_emptydir('etc/dconf/db')"
    substituteInPlace config/dconf/meson.build \
      --replace-fail "install_dir: '/etc/dconf/profile'" "install_dir: 'etc/dconf/profile'"
  '';

  # netatalk probes for the LocalSearch schema at configure time.
  preConfigure = lib.optionalString localsearchSupport ''
    export XDG_DATA_DIRS="''${XDG_DATA_DIRS:+$XDG_DATA_DIRS:}${localsearch}/share/gsettings-schemas/localsearch-${localsearch.version}"
  '';

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
