{ lib
, stdenv
, atk
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
, gtk4
, clang
, llvmPackages
, linux-pam
, pango
, cmake
, glib
, freetype
, fontconfig
, rdkafka
, udev
, libevdev
, alsa-lib
, ...
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
in
{
  alsa-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ alsa-lib ];
  };

  cairo-rs = attrs: {
    buildInputs = [ cairo ];
  };

  cairo-sys-rs = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ cairo ];
  };

  capnp-rpc = attrs: {
    nativeBuildInputs = [ capnproto ];
  };

  cargo = attrs: {
    buildInputs = [ openssl zlib curl ]
      ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];
  };

  libz-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zlib ];
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
  };

  curl-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zlib curl ];
    propagatedBuildInputs = [ curl zlib ];
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
  };

  dbus = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ dbus ];
  };

  evdev-sys = attrs: {
    buildInputs = [ libevdev ];
  };

  expat-sys = attrs: {
    nativeBuildInputs = [ cmake ];
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

  freetype-sys = attrs: {
    nativeBuildInputs = [ cmake ];
    buildInputs = [ freetype ];
  };

  glib-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ glib ];
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

  gtk4-sys = attrs: {
    buildInputs = [ gtk4 ];
    nativeBuildInputs = [ pkg-config ];
  };

  gdk4-sys = attrs: {
    buildInputs = [ gtk4 ];
    nativeBuildInputs = [ pkg-config ];
  };

  gsk4-sys = attrs: {
    buildInputs = [ gtk4 ];
    nativeBuildInputs = [ pkg-config ];
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

  libudev-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ udev ];
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

  pam-sys = attr: {
    buildInputs = [ linux-pam ];
  };

  pango-sys = attr: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ pango ];
  };

  pq-sys = attr: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ postgresql ];
  };

  rdkafka-sys = attr: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ rdkafka ];
  };

  rink = attrs: {
    buildInputs = [ gmp ];
    crateBin = [{ name = "rink"; path = "src/bin/rink.rs"; }];
  };

  security-framework-sys = attr: {
    propagatedBuildInputs = lib.optional stdenv.isDarwin Security;
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

  pangocairo-sys = attr: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ pango ];
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

  servo-fontconfig-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ freetype fontconfig ];
  };

  thrussh-libsodium = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libsodium ];
  };

  xcb = attrs: {
    buildInputs = [ python3 ];
  };

  atk-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ atk ];
  };

}
