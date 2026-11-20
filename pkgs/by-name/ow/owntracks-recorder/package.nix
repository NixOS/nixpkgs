{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  mosquitto,
  curl,
  openssl,
  lmdb,
  lua5_2_compat,
  libsodium,
  libuuid,
  libconfig,
  testers,
  owntracks-recorder,
  nix-update-script,
}:
let
  lua = lua5_2_compat;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "owntracks-recorder";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "owntracks";
    repo = "recorder";
    rev = finalAttrs.version;
    hash = "sha256-kob2hKz8sgMhJbZP7kE7Seo4n2+TAw0a8Pd2c73ptJs=";
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

  # Upstream only links in `libm` when `WITH_LUA = no`, and otherwise expects lua's pkg-config to provide it.
  # The lua pkg-config in nixpkgs doesn't provide it, so we have to link it in explictily.
  makeFlags = [ "LIBLM=yes" ];

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

  passthru = {
    tests.version = testers.testVersion {
      package = owntracks-recorder;
      command = "ocat --version";
      version = finalAttrs.version;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Store and access data published by OwnTracks apps";
    homepage = "https://github.com/owntracks/recorder";
    changelog = "https://github.com/owntracks/recorder/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.aionescu ];
    mainProgram = "ot-recorder";
  };
})
