{
  lib,
  stdenv,
  cjson,
  cmake,
  curl,
  doxygen,
  fetchFromGitHub,
  glib,
  gnutls,
  gpgme,
  hiredis,
  libgcrypt,
  libnet,
  libpcap,
  libssh,
  libuuid,
  libxcrypt,
  libxml2,
  openldap,
  paho-mqtt-c,
  pkg-config,
  radcli,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gvm-libs";
  version = "22.34.0";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-libs";
    tag = "v${version}";
    hash = "sha256-MCriCweaB2UbQzW/ojsyJgh/bn9l5XHqSicGYTnfQrw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "-Werror" ""
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    cjson
    curl
    glib
    gnutls
    gpgme
    hiredis
    libgcrypt
    libnet
    libpcap
    libssh
    libuuid
    libxcrypt
    libxml2
    openldap
    paho-mqtt-c
    radcli
    zlib
  ];

  cmakeFlags = [ "-DGVM_RUN_DIR=${placeholder "out"}/run/gvm" ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = {
    description = "Libraries module for the Greenbone Vulnerability Management Solution";
    homepage = "https://github.com/greenbone/gvm-libs";
    changelog = "https://github.com/greenbone/gvm-libs/releases/tag/${src.tag}";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
