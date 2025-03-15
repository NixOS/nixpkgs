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

  cmakeFlags =
    let
      # These tests require running services, which the checkPhase is ill equipeed to provide
      # TODO get them running in a nixosTest
      excludeTestsRegex = lib.concatStringsSep "|" [
        "Redis"
        "DataODBC"
        "MongoDB"
        "DataMySQL"
      ];
    in
    [
      # use nix provided versions of sqlite, zlib, pcre, expat, ... instead of bundled versions
      (lib.cmakeBool "POCO_UNBUNDLED" true)
      (lib.cmakeBool "ENABLE_TESTS" true)
      (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'${excludeTestsRegex}'")
    ];

  patches = [
    # Remove on next release
    (fetchpatch {
      name = "disable-included-pcre-if-pcre-is-linked-staticly";
      # this happens when building pkgsStatic.poco
      url = "https://patch-diff.githubusercontent.com/raw/pocoproject/poco/pull/4879.patch";
      hash = "sha256-VFWuRuf0GPYFp43WKI8utl+agP+7a5biLg7m64EMnVo=";
    })
    # failing on darwin, could perhaps be patched / a fix upstreamed later
    ./disable-broken-tests.patch
  ];

  doCheck = true;
  preCheck = ''
    # workaround for some tests trying to write to /homeless-shelter
    export HOME=$(mktemp -d)
  '';

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
