{
  boost,
  cargo,
  fetchpatch,
  fetchurl,
  fstrm,
  lib,
  libbpf,
  libcap,
  libedit,
  libsodium,
  lua5_2_compat,
  net-snmp,
  nghttp2,
  nixosTests,
  openssl,
  pkg-config,
  protobuf,
  python3,
  re2,
  rustPlatform,
  stdenv,
  systemd,
  xdp-tools,
  zlib,
}:
let
  lua = lua5_2_compat;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dnsdist";
  version = "2.1.3";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${finalAttrs.version}.tar.xz";
    hash = "sha256-QcwiSBf/D3dTtG/luBTduSId2dv3bp6xoJ8Bw8XLtKo=";
  };

  patches = [
    # Fix build without hostname
    # https://github.com/PowerDNS/pdns/pull/18271 - should become part of 2.1.4
    (fetchpatch {
      url = "https://github.com/PowerDNS/pdns/commit/a9833e04ce84a8ebeed4039c7ec5e0e75516406d.patch";
      relative = "pdns/dnsdistdist";
      hash = "sha256-aM2xhk8Jesvbn5t+lu8tlb11lHM8thQ3Qf//VTcjri0=";
    })
  ];
  nativeBuildInputs = [
    cargo
    pkg-config
    protobuf
    python3
    python3.pkgs.pyyaml
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    boost
    fstrm # Required for DNSTAP
    libbpf
    libcap
    libedit
    libsodium
    lua
    net-snmp
    nghttp2
    openssl
    re2
    systemd
    xdp-tools # AF_XDP support
    zlib
  ];

  configureFlags = [
    "--with-libsodium"
    "--with-re2"
    "--enable-dnscrypt"
    "--enable-dnstap"
    "--enable-dns-over-tls"
    "--enable-dns-over-https"
    "--enable-yaml"
    "--with-ebpf"
    "--with-xsk"
    "--with-libcap"
    "--with-protobuf=yes"
    "--with-net-snmp"
    "--disable-dependency-tracking"
    "--enable-unit-tests"
    "--enable-systemd"
    "--with-boost=${boost.dev}"
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) cargoRoot src;
    hash = "sha256-GSfn3qu/LqBP5xtt9CaY4h8GjaIVtlMZe+Mf2bz9KNs=";
  };

  cargoRoot = "dnsdist-rust-lib/rust";

  doCheck = true;

  enableParallelBuilding = true;

  passthru.tests = nixosTests.dnsdist;

  meta = {
    changelog = "https://www.dnsdist.org/changelog.html";
    description = "DNS Loadbalancer";
    mainProgram = "dnsdist";
    homepage = "https://dnsdist.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jojosch ];
  };
})
