{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sqlite,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlitecpp";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = "sqlitecpp";
    rev = finalAttrs.version;
    hash = "sha256-lmXvh2z+6QLLUapsHouBuAxgBQwbC5XKq80sza6CaUI=";
  };

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    sqlite
    gtest
  ];
  doCheck = true;

  cmakeFlags = [
    "-DSQLITECPP_INTERNAL_SQLITE=OFF"
    "-DSQLITECPP_BUILD_TESTS=ON"
  ];

  meta = {
    homepage = "https://srombauts.github.io/SQLiteCpp/";
    description = "C++ SQLite3 wrapper";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.jbedo
      lib.maintainers.doronbehar
    ];
  };
})
