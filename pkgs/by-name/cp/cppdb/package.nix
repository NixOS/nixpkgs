{
  lib,
  stdenv,
  fetchurl,
  cmake,
  sqlite,
  libmysqlclient,
  libpq,
  unixODBC,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppdb";
  version = "0.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/cppcms/cppdb-${finalAttrs.version}.tar.bz2";
    sha256 = "0blr1casmxickic84dxzfmn3lm7wrsl4aa2abvpq93rdfddfy3nn";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    sqlite
    libmysqlclient
    libpq
    unixODBC
  ];

  cmakeFlags = [ "--no-warn-unused-cli" ];
  env.NIX_CFLAGS_COMPILE = "-I${libmysqlclient}/include/mysql -L${libmysqlclient}/lib/mysql";

  meta = {
    homepage = "http://cppcms.com/sql/cppdb/";
    description = "C++ Connectivity library that supports MySQL, PostgreSQL, Sqlite3 databases and generic ODBC drivers";
    platforms = lib.platforms.linux;
    license = lib.licenses.boost;
    maintainers = [ lib.maintainers.juliendehos ];
  };
})
