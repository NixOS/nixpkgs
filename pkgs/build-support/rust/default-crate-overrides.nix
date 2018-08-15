{ stdenv, pkgconfig, curl, darwin, libiconv, libgit2, libssh2,
  openssl, sqlite, zlib, dbus, dbus-glib, gdk_pixbuf, cairo, python3,
  libsodium, postgresql, gmp, ... }:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
in
{
  cargo = attrs: {
    buildInputs = [ openssl zlib curl ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation libiconv ];
    # TODO: buildRustCrate seems to use incorrect default inference
    crateBin = [ {  name = "cargo"; path = "src/bin/cargo.rs"; } ];
  };
  cargo-vendor = attrs: {
    buildInputs = [ openssl zlib curl ];
    # TODO: this defaults to cargo_vendor; needs to be cargo-vendor to
    # be considered a cargo subcommand.
    crateBin = [ { name = "cargo-vendor"; path = "src/main.rs"; } ];
  };
  curl-sys = attrs: {
    buildInputs = [ pkgconfig zlib curl ];
    propagatedBuildInputs = [ curl zlib ];
    extraLinkFlags = ["-L${zlib.out}/lib"];
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
  openssl = attrs: {
    buildInputs = [ openssl ];
  };
  openssl-sys = attrs: {
    buildInputs = [ pkgconfig openssl ];
  };

  dbus = attrs: {
    buildInputs = [ pkgconfig dbus ];
  };
  libdbus-sys = attrs: {
    buildInputs = [ pkgconfig dbus ];
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
  rink = attrs: {
    buildInputs = [ gmp ];
    crateBin = [ {  name = "rink"; path = "src/bin/rink.rs"; } ];
  };
  cairo-rs = attrs: {
    buildInputs = [ cairo ];
  };
  xcb = attrs: {
    buildInputs = [ python3 ];
  };

  thrussh-libsodium = attrs: {
    buildInputs = [ pkgconfig libsodium ];
  };
  pq-sys = attr: {
    buildInputs = [ pkgconfig postgresql ];
  };
  security-framework-sys = attr: {
    propagatedBuildInputs = [ Security ];
  };
}
