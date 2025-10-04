{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  zlib,
  pcre2,
  utf8proc,
  expat,
  sqlite,
  openssl,
  unixODBC,
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
    libmysqlclient
  ];

  propagatedBuildInputs = [
    zlib
    pcre2
    utf8proc
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
    (fetchpatch {
      name = "bump-vendored-expat-2.7.0.patch";
      url = "https://github.com/pocoproject/poco/commit/1bdc41329b1629ed5c7bb55f1ba0fde452a7b8ec.patch";
      hash = "sha256-azK6NhTh6PYaiJvXSj6w1YTTcCJVBnk0Yc9f6AatC70=";
    })
    (fetchpatch {
      name = "bump-vendored-expat-2.7.1.patch";
      url = "https://github.com/pocoproject/poco/commit/ddecf77d1cce1035ed1a99f560f92125a309f477.patch";
      hash = "sha256-rjYWGGttQOxhkd+WwE2ZOl6t439nTvRbZaY2ATjbr+c=";
    })
    (fetchpatch {
      name = "CVE-2025-6375.patch";
      url = "https://github.com/pocoproject/poco/commit/da7fcba551a06c4f91a5e06ba983a6afc2480ae6.patch";
      hash = "sha256-WYQ5MYHE2iBbstamWKmCQaZdK8DxeklEhCFH7mlHYiI=";
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
