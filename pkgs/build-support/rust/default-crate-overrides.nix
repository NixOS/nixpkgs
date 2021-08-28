{ lib, stdenv, pkg-config, curl, darwin, libiconv, libgit2, libssh2,
  openssl, sqlite, zlib, dbus, dbus-glib, gdk-pixbuf, cairo, python3,
  libsodium, postgresql, gmp, foundationdb, capnproto, nettle, clang,
  llvmPackages, ... }:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
in
{
  cairo-rs = attrs: {
    buildInputs = [ cairo ];
  };

  capnp-rpc = attrs: {
    nativeBuildInputs = [ capnproto ];
  };

  cargo = attrs: {
    buildInputs = [ openssl zlib curl ]
      ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security libiconv ];
  };

  libz-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zlib ];
    extraLinkFlags = ["-L${zlib.out}/lib"];
  };

  curl-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zlib curl ];
    propagatedBuildInputs = [ curl zlib ];
    extraLinkFlags = ["-L${zlib.out}/lib"];
  };

  dbus = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ dbus ];
  };

  foundationdb-sys = attrs: {
    buildInputs = [ foundationdb ];
    # needed for 0.4+ release, when the FFI bindings are auto-generated
    #
    # patchPhase = ''
    #   substituteInPlace ./foundationdb-sys/build.rs \
    #     --replace /usr/local/include ${foundationdb.dev}/include
    # '';
  };

  foundationdb = attrs: {
    buildInputs = [ foundationdb ];
  };

  gobject-sys = attrs: {
    buildInputs = [ dbus-glib ];
  };

  gio-sys = attrs: {
    buildInputs = [ dbus-glib ];
  };

  gdk-pixbuf-sys = attrs: {
    buildInputs = [ dbus-glib ];
  };

  gdk-pixbuf = attrs: {
    buildInputs = [ gdk-pixbuf ];
  };

  libgit2-sys = attrs: {
    LIBGIT2_SYS_USE_PKG_CONFIG = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl zlib libgit2 ];
  };

  libsqlite3-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ sqlite ];
  };

  libssh2-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl zlib libssh2 ];
  };

  libdbus-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ dbus ];
  };

  nettle-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ nettle clang ];
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  };

  openssl = attrs: {
    buildInputs = [ openssl ];
  };

  openssl-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];
  };

  pq-sys = attr: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ postgresql ];
  };

  rink = attrs: {
    buildInputs = [ gmp ];
    crateBin = [ {  name = "rink"; path = "src/bin/rink.rs"; } ];
  };

  security-framework-sys = attr: {
    propagatedBuildInputs = [ Security ];
  };

  sequoia-openpgp = attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-openpgp-ffi = attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-ipc = attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-guide = attrs: {
    buildInputs = [ gmp ];
  };

  sequoia-store = attrs: {
    nativeBuildInputs = [ capnproto ];
    buildInputs = [ sqlite gmp ];
  };

  sequoia-sq = attrs: {
    buildInputs = [ sqlite gmp ];
  };

  sequoia-tool = attrs: {
    nativeBuildInputs = [ capnproto ];
    buildInputs = [ sqlite gmp ];
  };

  serde_derive = attrs: {
    buildInputs = lib.optional stdenv.isDarwin Security;
  };

  thrussh-libsodium = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libsodium ];
  };

  xcb = attrs: {
    buildInputs = [ python3 ];
  };
}
