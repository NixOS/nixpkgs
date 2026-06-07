{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libpq,
  python3,
  postgresql,
  postgresqlTestHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpqxx";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    tag = finalAttrs.version;
    hash = "sha256-b7NgMzqu0VkAFZPmaeE0eOmsedL76MvFtWKlmD8UfAo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    libpq
  ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail '"\''${prefix}/''${CMAKE_INSTALL_INCLUDEDIR}' '"''${CMAKE_INSTALL_FULL_INCLUDEDIR}' \
      --replace-fail '"\''${prefix}/''${CMAKE_INSTALL_LIBDIR}' '"''${CMAKE_INSTALL_FULL_LIBDIR}'
  '';

  cmakeFlags = [
    "-DBUILD_DOC=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = lib.meta.availableOn stdenv.hostPlatform postgresqlTestHook;

  checkPhase = ''
    runHook preCheck

    test/runner

    runHook postCheck
  '';

  enableParallelBuilding = true;

  __structuredAttrs = true;

  strictDeps = true;

  meta = {
    changelog = "https://github.com/jtv/libpqxx/releases/tag/${finalAttrs.version}";
    description = "C++ library to access PostgreSQL databases";
    downloadPage = "https://github.com/jtv/libpqxx";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
