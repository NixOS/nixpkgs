{ lib
, stdenv
, alsa-lib
, atk
, autoconf
, automake
, cairo
, capnproto
, clang
, cmake
, curl
, darwin
, dbus
, dbus-glib
, fontconfig
, foundationdb
, freetype
, gdk-pixbuf
, glib
, gmp
, gobject-introspection
, graphene
, gtk3
, gtk4
, libevdev
, libgit2
, libsodium
, libssh2
, libtool
, linux-pam
, llvmPackages
, nettle
, oniguruma
, openssl
, pango
, pkg-config
, postgresql
, protobuf
, python3
, rdkafka
, sqlite
, udev
, zlib
, zstd
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
in
{
  alsa-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ alsa-lib ];
  };

  atk-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ atk ];
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
    nativeBuildInputs = [
      pkg-config
    ] ++ lib.optionals (stdenv.buildPlatform.config != stdenv.hostPlatform.config) [
      python3 autoconf automake libtool
    ];
    buildInputs = [ libevdev ];

    # This prevents libevdev's build.rs from trying to `git fetch` when HOST!=TARGET
    prePatch = ''
      touch libevdev/.git
    '';
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

  gtk-sys = attrs: {
    buildInputs = [ gtk3 ];
    nativeBuildInputs = [ pkg-config ];
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

  graphene-sys = attrs: {
    nativeBuildInputs = [ pkg-config gobject-introspection ];
    buildInputs = [ graphene ];
  };

  nettle-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ nettle clang ];
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  };

  onig_sys = attrs: {
    RUSTONIG_SYSTEM_LIBONIG = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ oniguruma ];
  };

  openssl = attrs: {
    buildInputs = [ openssl ];
  };

  openssl-sys = attrs: {
    OPENSSL_NO_VENDOR = 1;
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

  prost-build = attr: {
    nativeBuildInputs = [ protobuf ];
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

  zstd-sys = attrs: {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zstd ];
  };
}
