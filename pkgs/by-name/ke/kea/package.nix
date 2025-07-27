{
  stdenv,
  lib,
  fetchurl,

  # build time
  autoreconfHook,
  pkg-config,
  python3Packages,

  # runtime
  withMysql ? stdenv.buildPlatform.system == stdenv.hostPlatform.system,
  withPostgres ? stdenv.buildPlatform.system == stdenv.hostPlatform.system,
  boost186,
  libmysqlclient,
  log4cplus,
  openssl,
  libpq,
  python3,

  # tests
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "kea";
  version = "2.6.3"; # only even minor versions are stable

  src = fetchurl {
    url = "https://ftp.isc.org/isc/${pname}/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-ACQaWVX/09IVosCYxFJ/nX9LIDGIsnb5o2JQ3T2d1hI=";
  };

  patches = [
    ./dont-create-var.patch
  ];

  postPatch = ''
    substituteInPlace ./src/bin/keactrl/Makefile.am --replace-fail '@sysconfdir@' "$out/etc"
    # darwin special-casing just causes trouble
    substituteInPlace ./m4macros/ax_crypto.m4 --replace-fail 'apple-darwin' 'nope'
  '';

  outputs = [
    "out"
    "doc"
    "man"
  ];

  configureFlags = [
    "--enable-perfdhcp"
    "--enable-shell"
    "--localstatedir=/var"
    "--with-openssl=${lib.getDev openssl}"
  ]
  ++ lib.optional withPostgres "--with-pgsql=${libpq.pg_config}/bin/pg_config"
  ++ lib.optional withMysql "--with-mysql=${lib.getDev libmysqlclient}/bin/mysql_config";

  postConfigure = ''
    # Mangle embedded paths to dev-only inputs.
    sed -e "s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" -i config.report
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ (with python3Packages; [
    sphinxHook
    sphinx-rtd-theme
  ]);

  sphinxBuilders = [
    "html"
    "man"
  ];
  sphinxRoot = "doc/sphinx";

  buildInputs = [
    boost186 # does not build with 1.87 yet, see https://gitlab.isc.org/isc-projects/kea/-/merge_requests/2523
    libmysqlclient
    log4cplus
    openssl
    python3
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    kea = nixosTests.kea;
    prefix-delegation = nixosTests.systemd-networkd-ipv6-prefix-delegation;
    networking-scripted = lib.recurseIntoAttrs {
      inherit (nixosTests.networking.scripted) dhcpDefault dhcpSimple dhcpOneIf;
    };
    networking-networkd = lib.recurseIntoAttrs {
      inherit (nixosTests.networking.networkd) dhcpDefault dhcpSimple dhcpOneIf;
    };
  };

  meta = {
    # error: implicit instantiation of undefined template 'std::char_traits<unsigned char>'
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://downloads.isc.org/isc/kea/${version}/Kea-${version}-ReleaseNotes.txt";
    homepage = "https://kea.isc.org/";
    description = "High-performance, extensible DHCP server by ISC";
    longDescription = ''
      Kea is a new open source DHCPv4/DHCPv6 server being developed by
      Internet Systems Consortium. The objective of this project is to
      provide a very high-performance, extensible DHCP server engine for
      use by enterprises and service providers, either as is or with
      extensions and modifications.
    '';
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      fpletz
      hexa
    ];
  };
}
