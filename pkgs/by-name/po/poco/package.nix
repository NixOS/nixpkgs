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
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation rec {
  pname = "poco";

  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "pocoproject";
    repo = "poco";
    hash = "sha256-koREkrfAHWfpqITN5afiXwZg37Wve2Ftx8sr8t2bSV4=";
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
      excludeTestsRegex = lib.concatStringsSep "|" [
        # These tests require running services, which the checkPhase is ill equipeed to provide
        # TODO get them running in a nixosTest
        "Redis"
        "DataODBC"
        "MongoDB"
        "DataMySQL"
        # network not accessible from nix sandbox
        "NetSSL" # around 25 test failures
        "Net" # could be made to work when public network access is patched out
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
    # https://github.com/pocoproject/poco/issues/4977
    ./disable-flaky-tests.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./disable-broken-tests-darwin.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    ./disable-broken-tests-linux.patch
  ];

  doCheck = true;
  nativeCheckInputs = [
    # workaround for some tests trying to write to /homeless-shelter
    writableTmpDirAsHomeHook
  ];

  postFixup = ''
    grep -rlF INTERFACE_INCLUDE_DIRECTORIES "$dev/lib/cmake/Poco" | while read -r f; do
      substituteInPlace "$f" \
        --replace-quiet "$"'{_IMPORT_PREFIX}/include' ""
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
