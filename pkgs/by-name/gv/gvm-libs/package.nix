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
<<<<<<< HEAD
  version = "22.34.1";
=======
  version = "22.32.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-libs";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qvcQml3XnGraCwa2iY+QGshzdsNUwQH3+HXLPwq6+M4=";
=======
    hash = "sha256-obQfexzE4vHnmzFp3gzPiKhzQJXrr6RWlg4v08WP4zE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
