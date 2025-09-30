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
  mysql,
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
  # for some reason the package doesn't build with swig 4.3.0
  swig_4_2 = swig.overrideAttrs (prevAttrs: {
    version = "4.2.1";
    src = prevAttrs.src.override {
      hash = "sha256-VlUsiRZLScmbC7hZDzKqUr9481YXVwo0eXT/jy6Fda8=";
    };
  });

  inherit (python3Packages) paramiko pycairo pyodbc;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mysql-workbench";
  version = "8.0.43";

  src = fetchurl {
    url = "https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-E9fn72r35WrGzIOoDouIvJFZdpfw9sgDNHwEe/0DdUI=";
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
  ];

  postPatch = ''
    # For some reason CMakeCache.txt is part of source code, remove it
    rm -f build/CMakeCache.txt

    patchShebangs tools/get_wb_version.sh
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    jre
    ninja
    pkg-config
    swig_4_2
    wrapGAppsHook3
  ];

  buildInputs = [
    antlr4_13.runtime.cpp
    boost
    gdal
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
    (lib.cmakeFeature "ANTLR_JAR_PATH" "${antlr4_13.jarLocation}")
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
