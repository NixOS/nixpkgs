{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoconf,
  automake,
  cargo,
  libtool,
  pkg-config,
  cracklib,
  lmdb,
  json_c,
  linux-pam,
  libevent,
  libxcrypt,
  nspr,
  nss,
  openldap,
  withOpenldap ? true,
  db,
  withBdb ? true,
  cyrus_sasl,
  icu,
  net-snmp,
  withNetSnmp ? true,
  krb5,
  pcre2,
  python3,
  rustPlatform,
  rustc,
  openssl,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  zlib,
  rsync,
  withCockpit ? true,
  withAsan ? false,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "389-ds-base";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "389ds";
    repo = "389-ds-base";
    rev = "389-ds-base-${finalAttrs.version}";
    hash = "sha256-hRTK9xBu8v8+SGa/3IB8Alh/aGUiRRn2LmYOvXy0Yd4=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/389ds/389-ds-base/pull/6930
      name = "389-ds-base-rustc-1_89.patch";
      url = "https://github.com/389ds/389-ds-base/commit/1701419551c246e9dc21778b118220eeb2258125.patch";
      hash = "sha256-trzY/fDH3rs66DWbWI+PY46tIC9ShuVqspMHqEEKZYA=";
    })
    ./0001-remove-hard-coded-vendor-paths.patch
    (fetchpatch {
      # https://github.com/389ds/389-ds-base/security/advisories/GHSA-4qwg-c5j2-q4hp
      name = "CVE-2025-14905.patch";
      url = "https://github.com/389ds/389-ds-base/commit/2e424110def2e3998f6045e136fb0d43f47b7f5a.patch";
      hash = "sha256-ItxG0bnuNPWLClL677rChTDvDWXxJ2L6ygx4VY2v80w=";
    })
  ];

  cargoRoot = "src";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    name = "389-ds-base-${finalAttrs.version}";
    hash = "sha256-pNzMQjeBpmzFg6oWCxhLDmKGUKIW6jGmZQWai5Yunjc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    python3
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optional withCockpit rsync;

  buildInputs = [
    cracklib
    lmdb
    json_c
    linux-pam
    libevent
    libxcrypt
    nspr
    nss
    cyrus_sasl
    icu
    krb5
    pcre2
    openssl
    zlib
  ]
  ++ lib.optional withSystemd systemd
  ++ lib.optional withOpenldap openldap
  ++ lib.optional withBdb db
  ++ lib.optional withNetSnmp net-snmp;

  postPatch = ''
    patchShebangs ./buildnum.py ./ldap/servers/slapd/mkDBErrStrs.py
  '';

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';

  configureFlags = [
    "--enable-rust-offline"
    "--enable-autobind"
  ]
  ++ lib.optionals withSystemd [
    "--with-systemd"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ]
  ++ lib.optionals withOpenldap [
    "--with-openldap"
  ]
  ++ lib.optionals withBdb [
    "--with-db-inc=${lib.getDev db}/include"
    "--with-db-lib=${lib.getLib db}/lib"
  ]
  ++ lib.optionals withNetSnmp [
    "--with-netsnmp-inc=${lib.getDev net-snmp}/include"
    "--with-netsnmp-lib=${lib.getLib net-snmp}/lib"
  ]
  ++ lib.optionals (!withCockpit) [
    "--disable-cockpit"
  ]
  ++ lib.optionals withAsan [
    "--enable-asan"
    "--enable-debug"
  ];

  enableParallelBuilding = true;
  # Disable parallel builds as those lack some dependencies:
  #   ld: cannot find -lslapd: No such file or directory
  # https://hydra.nixos.org/log/h38bj77gav0r6jbi4bgzy1lfjq22k2wy-389-ds-base-2.3.1.drv
  enableParallelInstalling = false;

  doCheck = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=${placeholder "TMPDIR"}"
  ];

  passthru.version = finalAttrs.version;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.port389.org/";
    description = "Enterprise-class Open Source LDAP server for Linux";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ners ];
  };
})
