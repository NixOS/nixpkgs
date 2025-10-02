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
  enableProtoBuf ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdns-recursor";
  version = "5.2.5";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${finalAttrs.version}.tar.bz2";
    hash = "sha256-qKZXp6vW6dI3zdJnU/fc9czVuMSKyBILCNK41XodhWo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    sourceRoot = "pdns-recursor-${finalAttrs.version}/settings/rust";
    hash = "sha256-A3NX1zj9+9qCLTkfca3v8Rr8oc/zL/Ruknjl3g1aMG4=";
  };

  cargoRoot = "settings/rust";

  nativeBuildInputs = [
    cargo
    rustc
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
