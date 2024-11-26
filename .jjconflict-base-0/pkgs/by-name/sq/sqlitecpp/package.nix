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
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = "sqlitecpp";
    rev = finalAttrs.version;
    sha256 = "sha256-rsVFk4FsonrwpBd3TonkxilwWeOBocH8AyeB+71OBdI=";
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

  meta = with lib; {
    homepage = "https://srombauts.github.io/SQLiteCpp/";
    description = "C++ SQLite3 wrapper";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [
      maintainers.jbedo
      maintainers.doronbehar
    ];
  };
})
