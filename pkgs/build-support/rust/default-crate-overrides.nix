{ lib
, stdenv
, pkg-config
, curl
, darwin
, libgit2
, libssh2
, openssl
, sqlite
, zlib
, dbus
, dbus-glib
, gdk-pixbuf
, cairo
, python3
, libsodium
, postgresql
, gmp
, foundationdb
, capnproto
, nettle
, clang
, llvmPackages
, linux-pam
, cmake
, glib
, freetype
, rdkafka
, udev
, ...
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
in
{
  cairo-rs = _attrs: {
    buildInputs = [ cairo ];
  };

  capnp-rpc = _attrs: {
    nativeBuildInputs = [ capnproto ];
  };

  cargo = _attrs: {
    buildInputs = [ openssl zlib curl ]
      ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];
  };

  libz-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zlib ];
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
  };

  curl-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zlib curl ];
    propagatedBuildInputs = [ curl zlib ];
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
  };

  dbus = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ dbus ];
  };

  expat-sys = _attrs: {
    nativeBuildInputs = [ cmake ];
  };

  foundationdb-sys = _attrs: {
    buildInputs = [ foundationdb ];
    # needed for 0.4+ release, when the FFI bindings are auto-generated
    #
    # patchPhase = ''
    #   substituteInPlace ./foundationdb-sys/build.rs \
    #     --replace /usr/local/include ${foundationdb.dev}/include
    # '';
  };

  foundationdb = _attrs: {
    buildInputs = [ foundationdb ];
  };

  freetype-sys = _attrs: {
    nativeBuildInputs = [ cmake ];
    buildInputs = [ freetype ];
  };

  glib-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ glib ];
  };

  gobject-sys = _attrs: {
    buildInputs = [ dbus-glib ];
  };

  gio-sys = _attrs: {
    buildInputs = [ dbus-glib ];
  };

  gdk-pixbuf-sys = _attrs: {
    buildInputs = [ dbus-glib ];
  };

  gdk-pixbuf = _attrs: {
    buildInputs = [ gdk-pixbuf ];
  };

  libgit2-sys = _attrs: {
    LIBGIT2_SYS_USE_PKG_CONFIG = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl zlib libgit2 ];
  };

  libsqlite3-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ sqlite ];
  };

  libssh2-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl zlib libssh2 ];
  };

  libdbus-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ dbus ];
  };

  libudev-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ udev ];
  };

  nettle-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ nettle clang ];
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  };

  openssl = _attrs: {
    buildInputs = [ openssl ];
  };

  openssl-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];
  };

  pam-sys = _attr: {
    buildInputs = [ linux-pam ];
  };

  pq-sys = _attr: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ postgresql ];
  };

  rdkafka-sys = _attr: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ rdkafka ];
  };

  rink = _attrs: {
    buildInputs = [ gmp ];
    crateBin = [{ name = "rink"; path = "src/bin/rink.rs"; }];
  };

  security-framework-sys = _attr: {
    propagatedBuildInputs = [ Security ];
  };

  sequoia-openpgp = _attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-openpgp-ffi = _attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-ipc = _attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-guide = _attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-store = _attrs: {
    nativeBuildInputs = [ capnproto ];
    buildInputs = [ sqlite gmp ];
  };

  sequoia-sq = _attrs: {
    buildInputs = [ sqlite gmp ];
  };

  sequoia-tool = _attrs: {
    nativeBuildInputs = [ capnproto ];
    buildInputs = [ sqlite gmp ];
  };

  serde_derive = _attrs: {
    buildInputs = lib.optional stdenv.isDarwin Security;
  };

  servo-fontconfig-sys = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ freetype ];
  };

  thrussh-libsodium = _attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libsodium ];
  };

  xcb = _attrs: {
    buildInputs = [ python3 ];
  };
}
