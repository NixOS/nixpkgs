{
  lib,
  stdenv,
  fetchurl,
  removeReferencesTo,
  fstrm,
  libevent,
  openssl,
  pkg-config,
  protobuf,
  protobufc,
  systemdMinimal,
  nixosTests,
  config,
  # set default options for config values
  # maybe TODO: move these into a proper module
  # (after https://github.com/NixOS/nixpkgs/pull/489889?)
  bind8Stats ? config.nsd.bind8Stats or false,
  checking ? config.nsd.checking or false,
  ipv6 ? config.nsd.ipv6 or true,
  minimalResponses ? config.nsd.minimalResponses or true,
  mmap ? config.nsd.mmap or false,
  nsec3 ? config.nsd.nsec3 or true,
  ratelimit ? config.nsd.ratelimit or false,
  recvmmsg ? config.nsd.recvmmsg or false,
  rootServer ? config.nsd.rootServer or false,
  rrtypes ? config.nsd.rrtypes or false,
  zoneStats ? config.nsd.zoneStats or false,
  withDnstap ? true,
  withSystemd ? config.nsd.withSystemd or (lib.meta.availableOn stdenv.hostPlatform systemdMinimal),
  configFile ? config.nsd.configFile or "/etc/nsd/nsd.conf",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nsd";
  version = "4.15.0";

  src = fetchurl {
    url = "https://www.nlnetlabs.nl/downloads/nsd/nsd-${finalAttrs.version}.tar.gz";
    hash = "sha256-hPG+4ukqna20HZXsxkET5NPe+GIk3ndM2SADrdjE9XA=";
  };

  patches = [
    # https://github.com/NLnetLabs/nsd/pull/495 -- Without this patch, the build
    # breaks with { openssl = libressl; bind8Stats = true; }. The patch will be
    # included in 4.15.1, so we can drop it here on the next update.
    (fetchurl {
      url = "https://github.com/NLnetLabs/nsd/commit/15cf8736e3bfa0fd8f426b13637c44e638fa0d40.patch";
      hash = "sha256-JVazJ83U80ASZypjic0epE92PZd3F1yi8UU6EapdW5U=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    removeReferencesTo
  ]
  ++ lib.optionals withDnstap [ protobuf ];

  buildInputs = [
    libevent
    openssl
  ]
  ++ lib.optionals withSystemd [ systemdMinimal ]
  ++ lib.optionals withDnstap [
    fstrm
    # NSD links against libprotobuf-c, it's not just a build-time dependency.
    protobufc
  ];

  enableParallelBuilding = true;

  # Prevent the install script from copying nsd.conf.sample into /etc/nsd.
  postPatch = ''
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
    ++ edf withDnstap "dnstap"
    ++ edf withSystemd "systemd"
    ++ [
      "--with-ssl=${openssl.dev}"
      "--with-libevent=${libevent.dev}"
      "--with-nsd_conf_file=${configFile}"
      "--with-configdir=etc/nsd"
    ];

  postFixup = ''
    find "$out" -type f -exec remove-references-to -t ${openssl.dev} -t ${libevent.dev} '{}' +
  '';

  passthru.tests = {
    inherit (nixosTests) nsd;
  };

  meta = {
    homepage = "https://www.nlnetlabs.nl";
    description = "Authoritative only, high performance, simple and open source name server";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ruuda ];
  };
})
