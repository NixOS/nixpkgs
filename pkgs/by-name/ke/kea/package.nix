{
  stdenv,
  lib,
  fetchurl,

  # build time
  bison,
  flex,
  meson,
  ninja,
  pkg-config,
  python3Packages,

  # runtime
  boost,
  log4cplus,
  openssl,
  python3,
  withKrb5 ? true,
  krb5,
  withMysql ? stdenv.buildPlatform.system == stdenv.hostPlatform.system,
  libmysqlclient,
  withPostgresql ? stdenv.buildPlatform.system == stdenv.hostPlatform.system,
  libpq,

  # tests
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kea";
  version = "3.0.1"; # only even minor versions are stable

  src = fetchurl {
    url = "https://ftp.isc.org/isc/kea/${finalAttrs.version}/kea-${finalAttrs.version}.tar.xz";
    hash = "sha256-7IT+xLt/a50VqC51Wlcek0jrTW+8Yrs/bxKWzXokxWY=";
  };

  patches = [
    ./dont-create-system-paths.patch
  ];

  postPatch = ''
    patchShebangs \
      scripts/grabber.py \
      doc/sphinx/*.sh.in
  '';

  outputs = [
    "out"
    "doc"
    "python"
  ];

  mesonFlags = [
    (lib.mesonOption "crypto" "openssl")
    (lib.mesonEnable "krb5" withKrb5)
    (lib.mesonEnable "mysql" withMysql)
    (lib.mesonEnable "netconf" false) # missing libyang-cpp, sysinfo, libsysrepo-cpp
    (lib.mesonEnable "postgresql" withPostgresql)
    (lib.mesonOption "localstatedir" "/var")
    (lib.mesonOption "runstatedir" "/run")
  ];

  postConfigure = ''
    # Mangle embedded paths to dev-only inputs.
    for file in config.report meson-info/intro*.json; do
      sed -e "s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" -i "$file"
    done
  '';

  nativeBuildInputs = [
    bison
    flex
    meson
    ninja
    pkg-config
    python3
  ]
  ++ (with python3Packages; [
    sphinx
    sphinx-rtd-theme
  ]);

  buildInputs = [
    boost
    log4cplus
    openssl
    python3
  ]
  ++ lib.optionals withMysql [
    libmysqlclient
  ]
  ++ lib.optionals withPostgresql [
    libpq
  ]
  ++ lib.optionals withKrb5 [
    krb5
  ];

  postBuild = ''
    ninja doc
  '';

  postFixup = ''
    mkdir -p $python/lib
    mv $out/lib/python* $python/lib/
  '';

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
    changelog = "https://gitlab.isc.org/isc-projects/kea/-/wikis/Release-Notes/release-notes-${finalAttrs.version}";
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
})
