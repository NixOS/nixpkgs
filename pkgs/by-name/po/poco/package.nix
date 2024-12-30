{
  lib,
  stdenv,
  fetchFromGitHub,
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
    "-DPOCO_UNBUNDLED=ON"
  ];

  patches = [
    # poco builds its own version of pcre, disable it for static builds
    # https://github.com/pocoproject/poco/issues/4871
    ./disable-internal-pcre-files-for-static-builds.patch
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
