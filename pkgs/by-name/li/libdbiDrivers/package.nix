{
  lib,
  stdenv,
  fetchurl,
  libdbi,
  # TODO: migrate away from overriding packages to null
  libmysqlclient ? null,
  sqlite ? null,
  libpq ? null,
}:

stdenv.mkDerivation rec {
  pname = "libdbi-drivers";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/libdbi-drivers/libdbi-drivers-${version}.tar.gz";
    hash = "sha256-Q9LqzVc6T6/ylvqSXdl/vyrtvxrjXGJjR4IQxhAEyFQ=";
  };

  buildInputs = [
    libdbi
    sqlite
  ]
  ++ lib.optional (libmysqlclient != null) libmysqlclient;

  patches = [
    # https://sourceforge.net/p/libdbi-drivers/libdbi-drivers/ci/24f48b86c8988ee3aaebc5f303d71e9d789f77b6
    ./libdbi-drivers-0.9.0-buffer_overflow.patch
    # https://sourceforge.net/p/libdbi-drivers/libdbi-drivers/ci/470b58e15dc6f406899b1695aec7fc98986b8f14
    ./libdbi-drivers-0.9.0-470b58e15-wait-include.patch
    # https://sourceforge.net/p/libdbi-drivers/libdbi-drivers/ci/9f3788269befd2e4290eef1df4b014bc2385d801
    ./libdbi-drivers-0.9.0-9f378826-compare-type.patch
    # fix function pointer type mismatches in tests
    ./libdbi-drivers-0.9.0-function-types.patch
  ];

  postPatch = ''
    sed -i '/SQLITE3_LIBS/ s/-lsqlite/-lsqlite3/' configure;
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-docs"
    "--enable-libdbi"
    "--with-dbi-incdir=${libdbi}/include"
    "--with-dbi-libdir=${libdbi}/lib"
  ]
  ++ lib.optionals (libmysqlclient != null) [
    "--with-mysql"
    "--with-mysql-incdir=${lib.getDev libmysqlclient}/include/mysql"
    "--with-mysql-libdir=${libmysqlclient}/lib/mysql"
  ]
  ++ lib.optionals (sqlite != null) [
    "--with-sqlite3"
    "--with-sqlite3-incdir=${sqlite.dev}/include/sqlite"
    "--with-sqlite3-libdir=${sqlite.out}/lib/sqlite"
  ]
  ++ lib.optionals (libpq != null) [
    "--with-pgsql"
    "--with-pgsql-incdir=${libpq.dev}/include"
    "--with-pgsql-libdir=${libpq}/lib/"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=incompatible-function-pointer-types"
      "-Wno-error=int-conversion"
    ]
  );

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall = ''
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done

    # Remove the unneeded var/lib directories
    rm -rf $out/var
  '';

  meta = with lib; {
    homepage = "https://libdbi-drivers.sourceforge.net/";
    description = "Database drivers for libdbi";
    platforms = platforms.all;
    license = licenses.lgpl21;
    maintainers = [ ];
  };
}
