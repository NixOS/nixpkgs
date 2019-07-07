{ stdenv, pkgconfig, curl, darwin, libiconv, libgit2, libssh2,
  openssl, sqlite, zlib, dbus, dbus-glib, gdk_pixbuf, cairo, python3,
  libsodium, postgresql, gmp, foundationdb, ... }:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
in
{
  cairo-rs = attrs: {
    buildInputs = [ cairo ];
  };

  cargo = attrs: {
    buildInputs = [ openssl zlib curl ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation Security libiconv ];
  };

  cargo-vendor = attrs: {
    buildInputs = [ openssl zlib curl ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];
  };

  libz-sys = attrs: {
    buildInputs = [ pkgconfig zlib ];
    extraLinkFlags = ["-L${zlib.out}/lib"];
  };

  curl-sys = attrs: {
    buildInputs = [ pkgconfig zlib curl ];
    propagatedBuildInputs = [ curl zlib ];
    extraLinkFlags = ["-L${zlib.out}/lib"];
  };

  dbus = attrs: {
    buildInputs = [ pkgconfig dbus ];
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
    buildInputs = [ gdk_pixbuf ];
  };

  libgit2-sys = attrs: {
    LIBGIT2_SYS_USE_PKG_CONFIG = true;
    buildInputs = [ pkgconfig openssl zlib libgit2 ];
  };

  libsqlite3-sys = attrs: {
    buildInputs = [ pkgconfig sqlite ];
  };

  libssh2-sys = attrs: {
    buildInputs = [ pkgconfig openssl zlib libssh2 ];
  };

  libdbus-sys = attrs: {
    buildInputs = [ pkgconfig dbus ];
  };

  openssl = attrs: {
    buildInputs = [ openssl ];
  };

  openssl-sys = attrs: {
    buildInputs = [ pkgconfig openssl ];
  };

  pq-sys = attr: {
    buildInputs = [ pkgconfig postgresql ];
  };

  rink = attrs: {
    buildInputs = [ gmp ];
    crateBin = [ {  name = "rink"; path = "src/bin/rink.rs"; } ];
  };

  security-framework-sys = attr: {
    propagatedBuildInputs = [ Security ];
  };

  serde_derive = attrs: {
    buildInputs = stdenv.lib.optional stdenv.isDarwin Security;
  };

  thrussh-libsodium = attrs: {
    buildInputs = [ pkgconfig libsodium ];
  };

  xcb = attrs: {
    buildInputs = [ python3 ];
  };
}
