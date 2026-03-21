{
  boost,
  cargo,
  fetchpatch,
  fetchurl,
  fstrm,
  h2o,
  lib,
  libbpf,
  libcap,
  libedit,
  libsodium,
  lua,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "dnsdist";
  version = "2.0.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${finalAttrs.version}.tar.xz";
    hash = "sha256-M3Trplpco8+5/Fl5HEflA1FJ/lIcy7ztX4NKF/RWQb8=";
  };

  patches = [
    # Fix build error when only protobuf is enabled
    (fetchpatch {
      url = "https://github.com/PowerDNS/pdns/commit/daece82818d7f83b26dcf724ec1864644bc3f854.patch";
      hash = "sha256-Ag65Gjmm2m4yvRfqMjSo1EEJg/2EHWDBg15vSL5DKCU=";
      stripLen = 2;
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
    h2o
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
    hash = "sha256-nDAvgM3xb+95dcGIHiSKlFo4/0Rs5Evf1vvR5vF4MXs=";
  };

  cargoRoot = "dnsdist-rust-lib/rust";

  doCheck = true;

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) dnsdist;
  };

  meta = {
    description = "DNS Loadbalancer";
    mainProgram = "dnsdist";
    homepage = "https://dnsdist.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jojosch ];
  };
})
