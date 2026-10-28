{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  replaceVars,

  cmake,
  jre,
  ninja,
  pkg-config,
  swig,
  wrapGAppsHook3,

  bash,
  coreutils,
  glibc,
  sudo,

  python3Packages,

  cairo,
  mysql84,
  libiodbc,
  proj,

  antlr4_13,
  boost,
  gdal,
  gtkmm3,
  libmysqlconnectorcpp,
  libsecret,
  libssh,
  libuuid,
  libxml2,
  libzip,
  openssl,
  rapidjson,
  vsqlite,
  zstd,
}:

let
  mysql = mysql84.client;
  gdal' = gdal.override { libmysqlclient = mysql; };
  antlr = antlr4_13;

  # for some reason the package doesn't build with swig 4.3.0
  swig' = swig.overrideAttrs (prevAttrs: {
    version = "4.2.1";
    src = prevAttrs.src.override {
      hash = "sha256-VlUsiRZLScmbC7hZDzKqUr9481YXVwo0eXT/jy6Fda8=";
    };
  });

  inherit (python3Packages) paramiko pycairo pyodbc;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mysql-workbench";
  version = "8.0.46";

  src = fetchurl {
    url = "https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-sP7GYSagPpcBhmdCynvQsxJexe54Bgu6RI7apCSb9TE=";
  };

  patches = [
    (replaceVars ./hardcode-paths.patch {
      bash = lib.getExe bash;
      catchsegv = lib.getExe' glibc "catchsegv";
      coreutils = lib.getBin coreutils;
      sudo = lib.getExe sudo;
    })

    # Fix swig not being able to find headers
    # https://github.com/NixOS/nixpkgs/pull/82362#issuecomment-597948461
    (replaceVars ./fix-swig-build.patch {
      cairoDev = lib.getDev cairo;
    })

    # Don't try to override the ANTLR_JAR_PATH specified in cmakeFlags
    ./dont-search-for-antlr-jar.patch

    # fixes the build with python 3.13
    (fetchpatch {
      name = "python3.13.patch";
      url = "https://git.pld-linux.org/?p=packages/mysql-workbench.git;a=blob_plain;f=python-3.13.patch;h=d1425a93c41fb421603cda6edbb0514389cdc6a8;hb=bb09cb858f3b9c28df699d3b98530a6c590b5b7a";
      hash = "sha256-hLfPqZSNf3ls2WThF1SBRjV33zTUymfgDmdZVpgO22Q=";
    })
    ./fix-missing-static-assert-include.patch
  ];

  postPatch = ''
    # For some reason CMakeCache.txt is part of source code, remove it
    rm -f build/CMakeCache.txt

    patchShebangs tools/get_wb_version.sh

    # Fix error: array subscript 1 is outside array bounds of 'bec::NodeId [1]' [-Werror=array-bounds=]
    # At /frontend/linux/workbench/overview_panel.cpp:1318:35
    substituteInPlace frontend/linux/workbench/overview_panel.cpp \
      --replace-fail 'std::vector<bec::NodeId> nodes(1);' 'std::vector<bec::NodeId> nodes;'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    jre
    ninja
    pkg-config
    swig'
    wrapGAppsHook3
  ];

  buildInputs = [
    antlr.runtime.cpp
    boost
    gdal'
    gtkmm3
    libiodbc
    libmysqlconnectorcpp
    libsecret
    libssh
    libuuid
    (libxml2.override { enableHttp = true; })
    libzip
    openssl
    rapidjson
    vsqlite
    zstd

    bash # for shebangs

    # python dependencies:
    paramiko
    pycairo
    pyodbc
    # TODO: package sqlanydb and add it here
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      # error: 'OGRErr OGRSpatialReference::importFromWkt(char**)' is deprecated
      "-Wno-error=deprecated-declarations"
      # library/forms/home_screen_connections.cpp:1353:7: error: variable 'row' set but not used
      "-Wno-error=unused-but-set-variable="
      # frontend/linux/linux_utilities/listmodel_wrapper.h:251:7: error: defining 'ListModelWrapper', which previously failed to be complete in a SFINAE context
      "-Wno-error=sfinae-incomplete"
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
    (lib.cmakeFeature "MySQL_CONFIG_PATH" (lib.getExe' mysql "mysql_config"))
    (lib.cmakeFeature "IODBC_CONFIG_PATH" (lib.getExe' libiodbc "iodbc-config"))
    (lib.cmakeFeature "ANTLR_JAR_PATH" "${antlr.jarLocation}")
    # mysql-workbench 8.0.21 depends on libmysqlconnectorcpp 1.1.8.
    # Newer versions of connector still provide the legacy library when enabled
    # but the headers are in a different location.
    (lib.cmakeFeature "MySQLCppConn_INCLUDE_DIR" "${lib.getDev libmysqlconnectorcpp}/include/jdbc")
  ];

  # There is already an executable and a wrapper in bindir
  # No need to wrap both
  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ python3Packages.python ]}"
      --prefix PROJSO : "${lib.getLib proj}/lib/libproj.so"
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
