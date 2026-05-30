{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  docbook_xsl,
  libxslt,
  c-ares,
  cjson,
  libargon2,
  libuuid,
  libuv,
  libwebsockets,
  openssl,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  sqlite,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "mosquitto";
  version = "2.1.2";
  # Tests disabled: upstream test suite requires additional Python deps,
  # uses chown() to fixed UIDs, and relies on signal handling that breaks
  # in sandboxed builds. Re-enable once upstream tests are sandbox-friendly.
  doCheck = false;

  src = fetchFromGitHub {
    owner = "eclipse-mosquitto";
    repo = "mosquitto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zl55yjuzQY2fyaKs/zLaJ7a3OONKTDQPaT+DpPURdZI=";
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
    libargon2
    libuuid
    libuv
    libwebsockets'
    openssl
    sqlite
    uthash
  ]
  ++ lib.optional withSystemd systemd;

  propagatedBuildInputs = [ cjson ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_BUNDLED_DEPS" false)
    (lib.cmakeBool "WITH_WEBSOCKETS" true)
    (lib.cmakeBool "WITH_SYSTEMD" withSystemd)
    (lib.cmakeBool "WITH_TESTS" finalAttrs.doCheck)
  ];

  postFixup = ''
    sed -i "s|^libdir=.*|libdir=$lib/lib|g" $dev/lib/pkgconfig/*.pc
  '';

  passthru.tests = {
    inherit (nixosTests) mosquitto;
  };

  meta = {
    description = "Open source MQTT v3.1/3.1.1/5.0 broker";
    homepage = "https://mosquitto.org/";
    changelog = "https://github.com/eclipse-mosquitto/mosquitto/blob/v2.0.22/ChangeLog.txt";
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [
      peterhoeg
      sikmir
    ];
    platforms = lib.platforms.unix;
    mainProgram = "mosquitto";
  };
})
