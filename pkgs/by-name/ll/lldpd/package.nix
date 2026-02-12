{
  stdenv,
  fetchurl,
  lib,
  libevent,
  net-snmp,
  openssl,
  pkg-config,
  readline,
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lldpd";
  version = "1.0.20";

  src = fetchurl {
    url = "https://media.luffy.cx/files/lldpd/lldpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-YbjLItSHnmj3glovuOHpKrtKukdzl3zwJYvDLtn1VFA=";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-pie"
    "--with-snmp"
    "--with-systemdsystemunitdir=\${out}/lib/systemd/system"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-launchddaemonsdir=no"
    "--with-privsep-chroot=/var/empty"
    "--with-privsep-group=nogroup"
    "--with-privsep-user=nobody"
  ];

  nativeBuildInputs = [
    pkg-config
    removeReferencesTo
  ];
  buildInputs = [
    libevent
    readline
    net-snmp
    openssl
  ];

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    # Yes, this works and is required for cross :'/
    export PATH=$PATH:${net-snmp.dev}/bin
  '';

  enableParallelBuilding = true;

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
  '';

  meta = {
    description = "802.1ab implementation (LLDP) to help you locate neighbors of all your equipments";
    homepage = "https://lldpd.github.io/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.unix;
  };
})
