{
  lib,
  stdenv,
  fetchurl,
  bison,
  cmake,
  pkg-config,
  icu,
  libedit,
  libevent,
  lz4,
  ncurses,
  openssl,
  protobuf_21,
  re2,
  readline,
  zlib,
  zstd,
  libfido2,
  darwin,
  numactl,
  libtirpc,
  rpcsvc-proto,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mysql";
  version = "8.4.3";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/MySQL-${lib.versions.majorMinor finalAttrs.version}/mysql-${finalAttrs.version}.tar.gz";
    hash = "sha256-eslWTEeAIvcwBf+Ju7QPZ7OB/AbVUYQWvf/sdeYluBg=";
  };

  nativeBuildInputs = [
    bison
    cmake
    pkg-config
  ] ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ];

  patches = [
    ./no-force-outline-atomics.patch # Do not force compilers to turn on -moutline-atomics switch
  ];

  ## NOTE: MySQL upstream frequently twiddles the invocations of libtool. When updating, you might proactively grep for libtool references.
  postPatch = ''
    substituteInPlace cmake/libutils.cmake --replace /usr/bin/libtool libtool
    substituteInPlace cmake/os/Darwin.cmake --replace /usr/bin/libtool libtool
  '';

  buildInputs =
    [
      (curl.override { inherit openssl; })
      icu
      libedit
      libevent
      lz4
      ncurses
      openssl
      protobuf_21
      re2
      readline
      zlib
      zstd
      libfido2
    ]
    ++ lib.optionals stdenv.isLinux [
      numactl
      libtirpc
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.cctools
      darwin.apple_sdk.frameworks.CoreServices
      darwin.developer_cmds
      darwin.DarwinTools
    ];

  outputs = [
    "out"
    "static"
  ];

  cmakeFlags = [
    "-DFORCE_UNSUPPORTED_COMPILER=1" # To configure on Darwin.
    "-DWITH_ROUTER=OFF" # It may be packaged separately.
    "-DWITH_SYSTEM_LIBS=ON"
    "-DWITH_UNIT_TESTS=OFF"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DINSTALL_INCLUDEDIR=include/mysql"
    "-DINSTALL_DOCREADMEDIR=share/mysql"
    "-DINSTALL_SUPPORTFILESDIR=share/mysql"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
    "-DINSTALL_MYSQLTESTDIR="
    "-DINSTALL_DOCDIR=share/mysql/docs"
    "-DINSTALL_SHAREDIR=share/mysql"
  ];

  postInstall = ''
    moveToOutput "lib/*.a" $static
    so=${stdenv.hostPlatform.extensions.sharedLibrary}
    ln -s libmysqlclient$so $out/lib/libmysqlclient_r$so
  '';

  passthru = {
    client = finalAttrs.finalPackage;
    connector-c = finalAttrs.finalPackage;
    server = finalAttrs.finalPackage;
    mysqlVersion = lib.versions.majorMinor finalAttrs.version;
  };

  meta = with lib; {
    homepage = "https://www.mysql.com/";
    description = "The world's most popular open source database";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      orivej
      shyim
    ];
    platforms = platforms.unix;
  };
})
