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
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = "sqlitecpp";
    rev = finalAttrs.version;
    hash = "sha256-RSNJGfvIvNfk+/Awzh06tDi/TA5Wc35X8ya0X5mP9IE=";
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
