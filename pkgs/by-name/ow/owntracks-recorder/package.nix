{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  mosquitto,
  curl,
  openssl,
  lmdb,
  lua,
  libsodium,
  libuuid,
  libconfig,
  testers,
  owntracks-recorder,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "owntracks-recorder";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "owntracks";
    repo = "recorder";
    rev = finalAttrs.version;
    hash = "sha256-/nLt8R8s3k6MQhtMXOLUDluuU7eNwZGYh5/km8tXtiE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    (lib.getDev curl)
    (lib.getLib libconfig)
    (lib.getDev openssl)
    (lib.getDev lmdb)
    (lib.getDev mosquitto)
    (lib.getDev libuuid)
    (lib.getDev lua)
    (lib.getDev libsodium)
  ];

  configurePhase = ''
    runHook preConfigure

    cp config.mk.in config.mk

    substituteInPlace config.mk \
      --replace "INSTALLDIR = /usr/local" "INSTALLDIR = $out" \
      --replace "DOCROOT = /var/spool/owntracks/recorder/htdocs" "DOCROOT = $out/htdocs" \
      --replace "WITH_LUA ?= no" "WITH_LUA ?= yes" \
      --replace "WITH_ENCRYPT ?= no" "WITH_ENCRYPT ?= yes"

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    install -m 0755 ot-recorder $out/bin
    install -m 0755 ocat $out/bin

    cp -r docroot $out/htdocs

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = owntracks-recorder;
    command = "ocat --version";
    version = finalAttrs.version;
  };

  meta = with lib; {
    description = "Store and access data published by OwnTracks apps";
    homepage = "https://github.com/owntracks/recorder";
    changelog = "https://github.com/owntracks/recorder/blob/master/Changelog";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "ot-recorder";
  };
})
