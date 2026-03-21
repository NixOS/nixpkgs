{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  nettle,
  libidn,
  libnetfilter_conntrack,
  nftables,
  buildPackages,
  dbusSupport ? stdenv.hostPlatform.isLinux,
  dbus,
  nixosTests,
}:

let
  copts = lib.concatStringsSep " " (
    [
      "-DHAVE_IDN"
      "-DHAVE_DNSSEC"
    ]
    ++ lib.optionals dbusSupport [
      "-DHAVE_DBUS"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "-DHAVE_CONNTRACK"
      "-DHAVE_NFTSET"
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dnsmasq";
  version = "2.92";

  src = fetchurl {
    url = "https://www.thekelleys.org.uk/dnsmasq/dnsmasq-${finalAttrs.version}.tar.xz";
    hash = "sha256-S/UMLBAY+fvCYDffUbkOzqDLc9RhYoRnY7kt8NbDpFg=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    sed '1i#include <linux/sockios.h>' -i src/dhcp.c
  '';

  preBuild = ''
    makeFlagsArray=("COPTS=${copts}")
  '';

  makeFlags = [
    "DESTDIR="
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/man"
    "LOCALEDIR=$(out)/share/locale"
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ];

  enableParallelBuilding = true;

  postBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    make -C contrib/lease-tools
  '';

  # XXX: Does the systemd service definition really belong here when our NixOS
  # module can create it in Nix-land?
  postInstall = ''
    install -Dm644 trust-anchors.conf $out/share/dnsmasq/trust-anchors.conf
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm644 contrib/MacOSX-launchd/uk.org.thekelleys.dnsmasq.plist \
      $out/Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist
    substituteInPlace $out/Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist \
      --replace "/usr/local/sbin" "$out/bin"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 contrib/lease-tools/dhcp_lease_time $out/bin/dhcp_lease_time
    install -Dm755 contrib/lease-tools/dhcp_release $out/bin/dhcp_release
    install -Dm755 contrib/lease-tools/dhcp_release6 $out/bin/dhcp_release6

  ''
  + lib.optionalString dbusSupport ''
    install -Dm644 dbus/dnsmasq.conf $out/share/dbus-1/system.d/dnsmasq.conf
    mkdir -p $out/share/dbus-1/system-services
    cat <<END > $out/share/dbus-1/system-services/uk.org.thekelleys.dnsmasq.service
    [D-BUS Service]
    Name=uk.org.thekelleys.dnsmasq
    Exec=$out/bin/dnsmasq -k -1
    User=root
    SystemdService=dnsmasq.service
    END
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    nettle
    libidn
  ]
  ++ lib.optionals dbusSupport [ dbus ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libnetfilter_conntrack
    nftables
  ];

  passthru.tests = {
    prometheus-exporter = nixosTests.prometheus-exporters.dnsmasq;

    # these tests use dnsmasq incidentally
    inherit (nixosTests) dnscrypt-proxy;
    kubernetes-dns-single = nixosTests.kubernetes.dns-single-node;
    kubernetes-dns-multi = nixosTests.kubernetes.dns-multi-node;
    pihole-ftl-dnsmasq = nixosTests.pihole-ftl.dnsmasq;
  };

  meta = {
    description = "Integrated DNS, DHCP and TFTP server for small networks";
    homepage = "https://www.thekelleys.org.uk/dnsmasq/doc.html";
    license = lib.licenses.gpl2Only;
    mainProgram = "dnsmasq";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      fpletz
    ];
  };
})
