{ stdenv, fetchurl, substituteAll, cmake, ninja, pkgconfig
, glibc, gtk3, gtkmm3, pcre, swig, antlr4_7, sudo
, mysql, libxml2, libmysqlconnectorcpp
, vsqlite, gdal, libiodbc, libpthreadstubs
, libXdmcp, libuuid, libzip, libsecret, libssh
, python2, jre
, boost, libsigcxx, libX11, openssl
, proj, cairo, libxkbcommon, epoxy, wrapGAppsHook
, at-spi2-core, dbus, bash, coreutils
}:

let
  inherit (python2.pkgs) paramiko pycairo pyodbc;
in stdenv.mkDerivation rec {
  pname = "mysql-workbench";
  version = "8.0.15";

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-${version}-src.tar.gz";
    sha256 = "0ca93azasya5xiw6j2map8drmxf445qqydpvrb512kjfqdiv67x6";
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
      sudo = "${sudo}/bin/sudo";
    })
  ];

  # have it look for 4.7.2 instead of 4.7.1
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace "antlr-4.7.1-complete.jar" "antlr-4.7.2-complete.jar"
  '';

  nativeBuildInputs = [
    cmake ninja pkgconfig jre swig wrapGAppsHook
  ];

  buildInputs = [
    gtk3 gtkmm3 libX11 antlr4_7.runtime.cpp python2 mysql libxml2
    libmysqlconnectorcpp vsqlite gdal boost libssh openssl
    libiodbc pcre cairo libuuid libzip libsecret
    libsigcxx proj
    # python dependencies:
    paramiko pycairo pyodbc # sqlanydb
    # transitive dependencies:
    libpthreadstubs libXdmcp libxkbcommon epoxy at-spi2-core dbus
  ];

  postPatch = ''
    patchShebangs tools/get_wb_version.sh
  '';

    # error: 'OGRErr OGRSpatialReference::importFromWkt(char**)' is deprecated
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  cmakeFlags = [
    "-DMySQL_CONFIG_PATH=${mysql}/bin/mysql_config"
    "-DIODBC_CONFIG_PATH=${libiodbc}/bin/iodbc-config"
    "-DWITH_ANTLR_JAR=${antlr4_7.jarLocation}"
  ];

  # There is already an executable and a wrapper in bindir
  # No need to wrap both
  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${python2}/bin"
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

  meta = with stdenv.lib; {
    description = "Visual MySQL database modeling, administration and querying tool";
    longDescription = ''
      MySQL Workbench is a modeling tool that allows you to design
      and generate MySQL databases graphically. It also has administration
      and query development modules where you can manage MySQL server instances
      and execute SQL queries.
    '';

    homepage = http://wb.mysql.com/;
    license = licenses.gpl2;
    maintainers = [ maintainers.kkallio ];
    platforms = platforms.linux;
  };
}
