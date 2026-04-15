{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  pkg-config,
  zlib,
  pcre2,
  utf8proc,
  expat,
  sqlite,
  openssl,
  unixodbc,
  libmysqlclient,
  libpng,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation rec {
  pname = "poco";

  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "pocoproject";
    repo = "poco";
    hash = "sha256-JyjEs5aecKSdrNEaSs4Dzs3mAu2rhhBNAG93VLHdU3E=";
    tag = "poco-${version}-release";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    unixodbc
    libmysqlclient
    libpng
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

  env = {
    MYSQL_DIR = libmysqlclient;
    MYSQL_INCLUDE_DIR = "${env.MYSQL_DIR}/include/mysql";
  };

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

  patches =
    lib.optionals stdenv.hostPlatform.isDarwin [
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=poco-(.*)-release" ];
  };

  meta = {
    homepage = "https://pocoproject.org/";
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      hythera
      tomodachi94
    ];
    platforms = lib.platforms.unix;
  };
}
