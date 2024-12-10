{
  lib,
  stdenv,
  fetchurl,
  substituteAll,
  cmake,
  ninja,
  pkg-config,
  glibc,
  gtk3,
  gtkmm3,
  pcre,
  swig,
  antlr4_12,
  sudo,
  mysql,
  libxml2,
  libmysqlconnectorcpp,
  vsqlite,
  gdal,
  libiodbc,
  libpthreadstubs,
  libXdmcp,
  libuuid,
  libzip,
  libsecret,
  libssh,
  python3,
  jre,
  boost,
  libsigcxx,
  libX11,
  openssl,
  rapidjson,
  proj,
  cairo,
  libxkbcommon,
  libepoxy,
  wrapGAppsHook3,
  at-spi2-core,
  dbus,
  bash,
  coreutils,
  zstd,
}:

let
  inherit (python3.pkgs) paramiko pycairo pyodbc;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mysql-workbench";
  version = "8.0.38";

  src = fetchurl {
    url = "https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-W2RsA2hIRUaNRK0Q5pN1YODbEiw6HE3cfeisPdUcYPY=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-paths.patch;
      catchsegv = "${glibc.bin}/bin/catchsegv";
      bash = "${bash}/bin/bash";
      cp = "${coreutils}/bin/cp";
      dd = "${coreutils}/bin/dd";
      ls = "${coreutils}/bin/ls";
      mkdir = "${coreutils}/bin/mkdir";
      nohup = "${coreutils}/bin/nohup";
      rm = "${coreutils}/bin/rm";
      rmdir = "${coreutils}/bin/rmdir";
      stat = "${coreutils}/bin/stat";
      sudo = "${sudo}/bin/sudo";
    })

    # Fix swig not being able to find headers
    # https://github.com/NixOS/nixpkgs/pull/82362#issuecomment-597948461
    (substituteAll {
      src = ./fix-swig-build.patch;
      cairoDev = "${cairo.dev}";
    })

    # Don't try to override the ANTLR_JAR_PATH specified in cmakeFlags
    ./dont-search-for-antlr-jar.patch
  ];

  postPatch = ''
    # For some reason CMakeCache.txt is part of source code, remove it
    rm -f build/CMakeCache.txt

    patchShebangs tools/get_wb_version.sh
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    jre
    swig
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtkmm3
    libX11
    antlr4_12.runtime.cpp
    python3
    mysql
    (libxml2.override { enableHttp = true; })
    libmysqlconnectorcpp
    vsqlite
    gdal
    boost
    libssh
    openssl
    rapidjson
    libiodbc
    pcre
    cairo
    libuuid
    libzip
    libsecret
    libsigcxx
    proj

    # python dependencies:
    paramiko
    pycairo
    pyodbc
    # TODO: package sqlanydb and add it here

    # transitive dependencies:
    libpthreadstubs
    libXdmcp
    libxkbcommon
    libepoxy
    at-spi2-core
    dbus
    zstd
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      # error: 'OGRErr OGRSpatialReference::importFromWkt(char**)' is deprecated
      "-Wno-error=deprecated-declarations"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # error: narrowing conversion of '-1' from 'int' to 'char'
      "-Wno-error=narrowing"
    ]
    ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
      # Needed with GCC 12 but problematic with some old GCCs
      "-Wno-error=maybe-uninitialized"
    ]
  );

  cmakeFlags = [
    "-DMySQL_CONFIG_PATH=${mysql}/bin/mysql_config"
    "-DIODBC_CONFIG_PATH=${libiodbc}/bin/iodbc-config"
    # mysql-workbench 8.0.21 depends on libmysqlconnectorcpp 1.1.8.
    # Newer versions of connector still provide the legacy library when enabled
    # but the headers are in a different location.
    "-DANTLR_JAR_PATH=${antlr4_12.jarLocation}"
    "-DMySQLCppConn_INCLUDE_DIR=${libmysqlconnectorcpp}/include/jdbc"
  ];

  # There is already an executable and a wrapper in bindir
  # No need to wrap both
  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${python3}/bin"
      --prefix PROJSO : "${proj}/lib/libproj.so"
      --set PYTHONPATH $PYTHONPATH
    )
  '';

  # Let’s wrap the programs not ending with bin
  # until https://bugs.mysql.com/bug.php?id=91948 is fixed
  postFixup = ''
    find -L "$out/bin" -type f -executable -print0 \
      | while IFS= read -r -d ''' file; do
      if [[ "''${file}" != *-bin ]]; then
        echo "Wrapping program $file"
        wrapGApp "$file"
      fi
    done
  '';

  meta = {
    description = "Visual MySQL database modeling, administration and querying tool";
    longDescription = ''
      MySQL Workbench is a modeling tool that allows you to design
      and generate MySQL databases graphically. It also has administration
      and query development modules where you can manage MySQL server instances
      and execute SQL queries.
    '';
    homepage = "http://wb.mysql.com/";
    license = lib.licenses.gpl2Only;
    mainProgram = "mysql-workbench";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
