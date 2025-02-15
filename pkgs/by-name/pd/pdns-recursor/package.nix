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
  version = "5.1.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${finalAttrs.version}.tar.bz2";
    hash = "sha256-s6N+uyAoWrmsu7DhNw5iO7OY7TCH8OZ48j/6OwBjmD0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    sourceRoot = "pdns-recursor-${finalAttrs.version}/settings/rust";
    hash = "sha256-/fxFqs5lDzOhatc6KBc7Zwsq3A7N5AOanGOebttr1l8=";
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
  ] ++ lib.optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--enable-systemd"
    "--enable-dns-over-tls"
    "sysconfdir=/etc/pdns-recursor"
  ];

  installFlags = [ "sysconfdir=$(out)/etc/pdns-recursor" ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) pdns-recursor ncdns;
  };

  meta = with lib; {
    description = "Recursive DNS server";
    homepage = "https://www.powerdns.com/";
    platforms = platforms.linux;
    badPlatforms = [
      "i686-linux" # a 64-bit time_t is needed
    ];
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ rnhmjoj ];
  };
})
