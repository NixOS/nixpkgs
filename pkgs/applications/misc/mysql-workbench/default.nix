{ lib, stdenv
, fetchurl
, substituteAll
, cmake
, ninja
, pkg-config
, glibc
, gtk3
, gtkmm3
, pcre
, swig
, antlr4_9
, sudo
, mysql
, libxml2
, libmysqlconnectorcpp
, vsqlite
, gdal
, libiodbc
, libpthreadstubs
, libXdmcp
, libuuid
, libzip
, libsecret
, libssh
, python3
, jre
, boost
, libsigcxx
, libX11
, openssl
, rapidjson
, proj
, cairo
, libxkbcommon
, libepoxy
, wrapGAppsHook
, at-spi2-core
, dbus
, bash
, coreutils
, zstd
}:

let
  inherit (python3.pkgs) paramiko pycairo pyodbc;
in stdenv.mkDerivation rec {
  pname = "mysql-workbench";
  version = "8.0.30";

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-${version}-src.tar.gz";
    sha256 = "d094b391760948f42a3b879e8473040ae9bb26991eced482eb982a52c8ff8185";
  };

  patches = [
    ./fix-gdal-includes.patch

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
  ];

  # 1. have it look for 4.9.3 instead of 4.9.1
  # 2. for some reason CMakeCache.txt is part of source code
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace "antlr-4.9.1-complete.jar" "antlr-4.9.3-complete.jar"
    rm -f build/CMakeCache.txt
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    jre
    swig
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtkmm3
    libX11
    antlr4_9.runtime.cpp
    python3
    mysql
    libxml2
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

  postPatch = ''
    patchShebangs tools/get_wb_version.sh
  '';

  NIX_CFLAGS_COMPILE = toString ([
    # error: 'OGRErr OGRSpatialReference::importFromWkt(char**)' is deprecated
    "-Wno-error=deprecated-declarations"
  ] ++ lib.optionals stdenv.isAarch64 [
    # error: narrowing conversion of '-1' from 'int' to 'char'
    "-Wno-error=narrowing"
  ]);

  cmakeFlags = [
    "-DMySQL_CONFIG_PATH=${mysql}/bin/mysql_config"
    "-DIODBC_CONFIG_PATH=${libiodbc}/bin/iodbc-config"
    # mysql-workbench 8.0.21 depends on libmysqlconnectorcpp 1.1.8.
    # Newer versions of connector still provide the legacy library when enabled
    # but the headers are in a different location.
    "-DWITH_ANTLR_JAR=${antlr4_9.jarLocation}"
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

  meta = with lib; {
    description = "Visual MySQL database modeling, administration and querying tool";
    longDescription = ''
      MySQL Workbench is a modeling tool that allows you to design
      and generate MySQL databases graphically. It also has administration
      and query development modules where you can manage MySQL server instances
      and execute SQL queries.
    '';

    homepage = "http://wb.mysql.com/";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
