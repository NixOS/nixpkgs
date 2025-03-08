{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  zlib,
  pcre2,
  expat,
  sqlite,
  openssl,
  unixODBC,
  utf8proc,
  libmysqlclient,
}:

stdenv.mkDerivation rec {
  pname = "poco";

  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "pocoproject";
    repo = "poco";
    hash = "sha256-acq2eja61sH/QHwMPmiDNns2jvXRTk0se/tHj9XRSiU=";
    rev = "poco-${version}-release";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    unixODBC
    utf8proc
    libmysqlclient
  ];

  propagatedBuildInputs = [
    zlib
    pcre2
    expat
    sqlite
    openssl
  ];

  outputs = [
    "out"
    "dev"
  ];

  MYSQL_DIR = libmysqlclient;
  MYSQL_INCLUDE_DIR = "${MYSQL_DIR}/include/mysql";

  cmakeFlags = [
    # use nix provided versions of sqlite, zlib, pcre, expat, ... instead of bundled versions
    (lib.cmakeBool "POCO_UNBUNDLED" true)
  ];

  patches = [
    # Remove on next release
    (fetchpatch {
      name = "disable-included-pcre-if-pcre-is-linked-staticly";
      # this happens when building pkgsStatic.poco
      url = "https://patch-diff.githubusercontent.com/raw/pocoproject/poco/pull/4879.patch";
      hash = "sha256-VFWuRuf0GPYFp43WKI8utl+agP+7a5biLg7m64EMnVo=";
    })
  ];

  postFixup = ''
    grep -rlF INTERFACE_INCLUDE_DIRECTORIES "$dev/lib/cmake/Poco" | while read -r f; do
      substituteInPlace "$f" \
        --replace "$"'{_IMPORT_PREFIX}/include' ""
    done
  '';

  meta = with lib; {
    homepage = "https://pocoproject.org/";
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = licenses.boost;
    maintainers = with maintainers; [
      orivej
      tomodachi94
    ];
    platforms = platforms.unix;
  };
}
