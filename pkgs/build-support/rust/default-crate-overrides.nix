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
, libsoup_3
, libssh2
, libtool
, linux-pam
, llvmPackages
, nettle
, openssl
, pango
, pkg-config
, postgresql
, protobuf
, python3
, rdkafka
, seatd # =libseat
, sqlite
, udev
, webkitgtk_4_1
, zlib
, buildPackages
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
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
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
      python3
      autoconf
      automake
      libtool
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
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
  };

  gobject-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ dbus-glib ];
  };

  gio-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ dbus-glib ];
  };

  gdk-pixbuf = attrs: {
    buildInputs = [ dbus-glib gdk-pixbuf ];
  };

  gdk-pixbuf-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ gdk-pixbuf ];
  };

  gdk-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ gtk3 ]; # libgdk-3
  };

  gdkx11-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ gtk3 ];
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

  libseat-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ seatd ];
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

  javascriptcore-rs-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ webkitgtk_4_1 ];
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

  opentelemetry-proto = attrs: {
    nativeBuildInputs = [ protobuf ];
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

  prost-wkt-types = attr: {
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

  soup3-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libsoup_3 ];
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
  };

  thrussh-libsodium = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libsodium ];
  };

  tonic-reflection = attrs: {
    nativeBuildInputs = [ protobuf ];
  };

  webkit2gtk-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ webkitgtk_4_1 ];
    extraLinkFlags = [ "-L${zlib.out}/lib" ];
  };

  xcb = attrs: {
    buildInputs = [ python3 ];
  };

  atk-sys = attrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ atk ];
  };

  # Assumes it can run Command::new(env::var("CARGO")).arg("locate-project")
  # https://github.com/bkchr/proc-macro-crate/blame/master/src/lib.rs#L244
  proc-macro-crate = attrs: lib.optionalAttrs (lib.versionAtLeast attrs.version "2.0") {
    prePatch = (attrs.prePatch or "") + ''
      substituteInPlace \
        src/lib.rs \
        --replace-fail \
        'env::var("CARGO").map_err(|_| Error::CargoEnvVariableNotSet)?' \
        '"${lib.getBin buildPackages.cargo}/bin/cargo"'
    '';
  };
}
