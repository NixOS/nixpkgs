{
  lib,
  stdenv,
  bison,
  cmake,
  curl,
  doxygen,
  fetchFromGitHub,
  file,
  git,
  glib,
  gnutls,
  gpgme,
  gvm-libs,
  json-glib,
  libbsd,
  libclang,
  libgcrypt,
  libksba,
  libpcap,
  libsepol,
  libssh,
  libtasn1,
  net-snmp,
  p11-kit,
  paho-mqtt-c,
  pandoc,
  pcre2,
  pkg-config,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openvas-scanner";
  version = "23.52.12";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "openvas-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7rbzJdE1Jjc2qB9mtOnjUbyEiBtZsDkJIOEUxsT+3Qk=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers -Wno-error=sign-compare";

  nativeBuildInputs = [
    cmake
    git
    doxygen
    pandoc
    pkg-config
  ];

  buildInputs = [
    bison
    curl
    file
    glib
    gnutls
    gpgme
    gvm-libs
    json-glib
    libbsd
    libclang
    libgcrypt
    libksba
    libpcap
    libsepol
    libssh
    libtasn1
    net-snmp
    p11-kit
    paho-mqtt-c
    pcre2
    util-linux
  ];

  cmakeFlags = [
    "-DGVM_RUN_DIR=$out/run/gvm"
    "-DLOCALSTATEDIR=$out/var"
    "-DSYSCONFDIR=$out/etc"
    "-DOPENVAS_RUN_DIR=$out/run/ospd"
    "-DOPENVAS_FEED_LOCK_PATH=$out/var/lib/openvas/feed-update.lock"
  ];

  meta = {
    description = "Scanner component for Greenbone Community Edition";
    homepage = "https://github.com/greenbone/openvas-scanner";
    changelog = "https://github.com/greenbone/openvas-scanner/blob/${finalAttrs.src.rev}/changelog.toml";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "openvas-scanner";
    platforms = lib.platforms.all;
  };
})
