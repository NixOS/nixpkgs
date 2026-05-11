{
  lib,
  stdenv,
  fetchurl,
  libevent,
  openssl,
  pkg-config,
  systemdMinimal,
  nixosTests,
  config,
  # set default options for config values
  # maybe TODO: move these into a proper module
  # (after https://github.com/NixOS/nixpkgs/pull/489889?)
  bind8Stats ? config.nsd.bind8Stats or false,
  checking ? config.nsd.checking or false,
  ipv6 ? config.nsd.ipv6 or true,
  mmap ? config.nsd.mmap or false,
  minimalResponses ? config.nsd.minimalResponses or true,
  nsec3 ? config.nsd.nsec3 or true,
  ratelimit ? config.nsd.ratelimit or false,
  recvmmsg ? config.nsd.recvmmsg or false,
  rootServer ? config.nsd.rootServer or false,
  rrtypes ? config.nsd.rrtypes or false,
  zoneStats ? config.nsd.zoneStats or false,
  withSystemd ? config.nsd.withSystemd or (lib.meta.availableOn stdenv.hostPlatform systemdMinimal),
  configFile ? config.nsd.configFile or "/etc/nsd/nsd.conf",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nsd";
  version = "4.12.0";

  src = fetchurl {
    url = "https://www.nlnetlabs.nl/downloads/nsd/nsd-${finalAttrs.version}.tar.gz";
    hash = "sha256-+ezCz3m6UFgPLfYpGO/EQAhMW/EQV9tEwZqpZDzUteg=";
  };

  nativeBuildInputs = lib.optionals withSystemd [
    pkg-config
  ];

  buildInputs = [
    libevent
    openssl
  ]
  ++ lib.optionals withSystemd [
    systemdMinimal
  ];

  enableParallelBuilding = true;

  # TODO: prePatch doesn't actually get executed because patchPhase is overridden
  prePatch = ''
    substituteInPlace nsd-control-setup.sh.in --replace openssl ${openssl}/bin/openssl
  '';

  patchPhase = ''
    sed 's@$(INSTALL_DATA) nsd.conf.sample $(DESTDIR)$(nsdconfigfile).sample@@g' -i Makefile.in
  '';

  configureFlags =
    let
      edf = c: o: if c then [ "--enable-${o}" ] else [ "--disable-${o}" ];
    in
    edf bind8Stats "bind8-stats"
    ++ edf checking "checking"
    ++ edf ipv6 "ipv6"
    ++ edf mmap "mmap"
    ++ edf minimalResponses "minimal-responses"
    ++ edf nsec3 "nsec3"
    ++ edf ratelimit "ratelimit"
    ++ edf recvmmsg "recvmmsg"
    ++ edf rootServer "root-server"
    ++ edf rrtypes "draft-rrtypes"
    ++ edf zoneStats "zone-stats"
    ++ edf withSystemd "systemd"
    ++ [
      "--with-ssl=${openssl.dev}"
      "--with-libevent=${libevent.dev}"
      "--with-nsd_conf_file=${configFile}"
      "--with-configdir=etc/nsd"
    ];

  passthru.tests = {
    inherit (nixosTests) nsd;
  };

  meta = {
    homepage = "https://www.nlnetlabs.nl";
    description = "Authoritative only, high performance, simple and open source name server";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
