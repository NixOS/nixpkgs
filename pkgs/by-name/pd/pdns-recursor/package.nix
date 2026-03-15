{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  boost,
  nixosTests,
  openssl,
  systemd,
  lua,
  luajit,
  protobuf,
  libsodium,
  curl,
  rustPlatform,
  cargo,
  rustc,
  python3,
  enableProtoBuf ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdns-recursor";
  version = "5.4.0";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${finalAttrs.version}.tar.xz";
    hash = "sha256-L2nvdYatyAW8T1A+FaNPDG3Pu/2rfZWf8TLY4s2/JQo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    sourceRoot = "pdns-recursor-${finalAttrs.version}/rec-rust-lib/rust";
    hash = "sha256-OBC6x1yL+kVpiBittZVvwMSCAsSyS0U9853x3TBGGkc=";
  };

  cargoRoot = "rec-rust-lib/rust";

  nativeBuildInputs = [
    cargo
    rustc
    python3
    rustPlatform.cargoSetupHook
    pkg-config
  ];

  buildInputs = [
    boost
    openssl
    systemd
    lua
    luajit
    libsodium
    curl
  ]
  ++ lib.optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--enable-systemd"
    "--enable-dns-over-tls"
    "--with-boost=${boost.dev}"
    "sysconfdir=/etc/pdns-recursor"
  ];

  installFlags = [ "sysconfdir=$(out)/etc/pdns-recursor" ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) pdns-recursor ncdns;
  };

  meta = {
    description = "Recursive DNS server";
    homepage = "https://www.powerdns.com/";
    platforms = lib.platforms.linux;
    badPlatforms = [
      "i686-linux" # a 64-bit time_t is needed
    ];
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
})
