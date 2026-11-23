{
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  jsoncpp,
  libossp_uuid,
  zlib,
  lib,
  # optional but of negligible size
  openssl,
  brotli,
  c-ares,
  # optional databases
  sqliteSupport ? true,
  sqlite,
  postgresSupport ? false,
  libpq,
  redisSupport ? false,
  hiredis,
  mysqlSupport ? false,
  libmysqlclient,
  mariadb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drogon";
  version = "1.9.14";

  src = fetchFromGitHub {
    owner = "drogonframework";
    repo = "drogon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hH6uewql77lh8f3807bxKHbl1xGSZvpeoDcGib/ImYI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    curl
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doInstallCheck)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
  ];

  propagatedBuildInputs = [
    jsoncpp
    libossp_uuid
    zlib
    openssl
    brotli
    c-ares
  ]
  ++ lib.optional sqliteSupport sqlite
  ++ lib.optional postgresSupport libpq
  ++ lib.optional redisSupport hiredis
  # drogon uses mariadb for mysql (see https://github.com/drogonframework/drogon/wiki/ENG-02-Installation#Library-Dependencies)
  ++ lib.optionals mysqlSupport [
    libmysqlclient
    mariadb
  ];

  patches = [
    # this part of the test would normally fail because it attempts to configure a CMake project that uses find_package on itself
    # this patch makes drogon and trantor visible to the test
    ./fix_find_package.patch
    ./ignore-nodiscard-result.patch
  ];

  # modifying PATH here makes drogon_ctl visible to the test
  installCheckPhase = ''
    (
      cd ..
      PATH=$PATH:$out/bin $SHELL test.sh
    )
  '';

  # this excludes you, pkgsStatic (cmake wants to run built binaries
  # in the buildPhase)
  doInstallCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  # The integration tests start a local HTTP server.
  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/drogonframework/drogon";
    description = "C++14/17 based HTTP web application framework";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
