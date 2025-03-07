{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  docbook_xsl,
  libxslt,
  c-ares,
  cjson,
  libuuid,
  libuv,
  libwebsockets,
  openssl,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  uthash,
  nixosTests,
}:

let
  # Mosquitto needs external poll enabled in libwebsockets.
  libwebsockets' =
    (libwebsockets.override {
      withExternalPoll = true;
    }).overrideAttrs
      (old: {
        # Avoid bug in firefox preventing websockets being created over http/2 connections
        # https://github.com/eclipse/mosquitto/issues/1211#issuecomment-958137569
        cmakeFlags = old.cmakeFlags ++ [ "-DLWS_WITH_HTTP2=OFF" ];
      });

in
stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "2.0.20";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "mosquitto";
    rev = "v${version}";
    hash = "sha256-oZo6J6mxMC05jJ8RXIunOMB3kptA6FElchKlg4qmuQ8=";
  };

  postPatch = ''
    for f in html manpage ; do
      substituteInPlace man/$f.xsl \
        --replace http://docbook.sourceforge.net/release/xsl/current ${docbook_xsl}/share/xml/docbook-xsl
    done
  '';

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    cmake
    docbook_xsl
    libxslt
  ];

  buildInputs = [
    c-ares
    cjson
    libuuid
    libuv
    libwebsockets'
    openssl
    uthash
  ] ++ lib.optional withSystemd systemd;

  cmakeFlags = [
    (lib.cmakeBool "WITH_BUNDLED_DEPS" false)
    (lib.cmakeBool "WITH_WEBSOCKETS" true)
    (lib.cmakeBool "WITH_SYSTEMD" withSystemd)
  ];

  postFixup = ''
    sed -i "s|^prefix=.*|prefix=$lib|g" $dev/lib/pkgconfig/*.pc
  '';

  passthru.tests = {
    inherit (nixosTests) mosquitto;
  };

  meta = {
    description = "Open source MQTT v3.1/3.1.1/5.0 broker";
    homepage = "https://mosquitto.org/";
    changelog = "https://github.com/eclipse/mosquitto/blob/v${version}/ChangeLog.txt";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.peterhoeg ];
    platforms = lib.platforms.unix;
    mainProgram = "mosquitto";
  };
}
